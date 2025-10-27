#!/bin/bash

# Script to create AWS S3 bucket for Terragrunt remote state
set -euo pipefail

# Default region
DEFAULT_REGION="us-east-1"

# Functions
usage() {
    echo "Usage: $0 -b BUCKET_NAME [-r REGION] [-p PROFILE]"
    echo "  -b    S3 bucket name for Terragrunt state (required)"
    echo "  -r    AWS region (default: us-east-1)"
    echo "  -p    AWS profile (optional)"
    exit 1
}

check_aws() {
    if ! command -v aws >/dev/null 2>&1; then
        echo "Error: AWS CLI is not installed"
        exit 1
    fi
}

check_bucket_name() {
    local bucket_name=$1
    if [[ ! $bucket_name =~ ^[a-z0-9.-]{3,63}$ ]]; then
        echo "Error: Invalid bucket name. Must be 3-63 characters, lowercase, numbers, dots, and hyphens only."
        exit 1
    fi
}

# Parse arguments
while getopts ":b:r:p:" opt; do
    case $opt in
        b) BUCKET_NAME="$OPTARG" ;;
        r) REGION="$OPTARG" ;;
        p) PROFILE="$OPTARG" ;;
        \?) echo "Invalid option -$OPTARG" >&2; usage ;;
    esac
done

# Validate required parameters
if [ -z "${BUCKET_NAME:-}" ]; then
    echo "Error: Bucket name is required"
    usage
fi

# Set region to default if not specified
REGION=${REGION:-$DEFAULT_REGION}

# Construct AWS CLI command prefix
AWS_CMD="aws"
if [ -n "${PROFILE:-}" ]; then
    AWS_CMD="$AWS_CMD --profile $PROFILE"
fi

# Main
echo "Checking prerequisites..."
check_aws
check_bucket_name "$BUCKET_NAME"

echo "Creating S3 bucket: $BUCKET_NAME"
$AWS_CMD s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$REGION" \
    $([ "$REGION" != "us-east-1" ] && echo "--create-bucket-configuration LocationConstraint=$REGION") \
    || { echo "Failed to create bucket"; exit 1; }

echo "Enabling versioning..."
$AWS_CMD s3api put-bucket-versioning \
    --bucket "$BUCKET_NAME" \
    --versioning-configuration Status=Enabled \
    || { echo "Failed to enable versioning"; exit 1; }

echo "Enabling default encryption..."
$AWS_CMD s3api put-bucket-encryption \
    --bucket "$BUCKET_NAME" \
    --server-side-encryption-configuration '{
        "Rules": [
            {
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }
        ]
    }' \
    || { echo "Failed to enable encryption"; exit 1; }

echo "Adding bucket policy for secure access..."
$AWS_CMD s3api put-bucket-policy \
    --bucket "$BUCKET_NAME" \
    --policy '{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "EnforcedTLSOnly",
                "Effect": "Deny",
                "Principal": "*",
                "Action": "s3:*",
                "Resource": [
                    "arn:aws:s3:::'$BUCKET_NAME'",
                    "arn:aws:s3:::'$BUCKET_NAME'/*"
                ],
                "Condition": {
                    "Bool": {
                        "aws:SecureTransport": "false"
                    }
                }
            }
        ]
    }' \
    || { echo "Failed to add bucket policy"; exit 1; }

echo "
Setup complete! Your Terragrunt backend is ready.

Add this to your terragrunt.hcl:

remote_state {
  backend = \"s3\"
  config = {
    bucket         = \"${BUCKET_NAME}\"
    key            = \"\${path_relative_to_include()}/terraform.tfstate\"
    region         = \"${REGION}\"
    encrypt        = true
  }
}
"
