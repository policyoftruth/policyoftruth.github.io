#!/bin/bash

# Script to apply free security hardening to existing S3 backend bucket
# This script adds public access blocking to your Terraform state bucket
set -euo pipefail

# Default values
DEFAULT_BUCKET="nulldiv-web-tf"
DEFAULT_REGION="us-east-1"

# Functions
usage() {
    echo "Usage: $0 [-b BUCKET_NAME] [-r REGION] [-p PROFILE]"
    echo "  -b    S3 bucket name (default: nulldiv-web-tf)"
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

# Parse arguments
while getopts ":b:r:p:h" opt; do
    case $opt in
        b) BUCKET_NAME="$OPTARG" ;;
        r) REGION="$OPTARG" ;;
        p) PROFILE="$OPTARG" ;;
        h) usage ;;
        \?) echo "Invalid option -$OPTARG" >&2; usage ;;
    esac
done

# Set defaults if not specified
BUCKET_NAME=${BUCKET_NAME:-$DEFAULT_BUCKET}
REGION=${REGION:-$DEFAULT_REGION}

# Construct AWS CLI command prefix
AWS_CMD="aws"
if [ -n "${PROFILE:-}" ]; then
    AWS_CMD="$AWS_CMD --profile $PROFILE"
fi

# Main
echo "==================================================================="
echo "S3 Backend Security Hardening (FREE improvements only)"
echo "==================================================================="
echo ""
echo "Bucket: $BUCKET_NAME"
echo "Region: $REGION"
echo ""

check_aws

# Check if bucket exists
echo "Checking if bucket exists..."
if ! $AWS_CMD s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "Error: Bucket $BUCKET_NAME does not exist or you don't have access"
    exit 1
fi
echo "✓ Bucket exists"
echo ""

# Get current configuration
echo "Current Security Status:"
echo "------------------------"

# Check versioning
VERSIONING=$($AWS_CMD s3api get-bucket-versioning --bucket "$BUCKET_NAME" --query 'Status' --output text 2>/dev/null || echo "None")
echo "Versioning: $VERSIONING"

# Check encryption
ENCRYPTION=$($AWS_CMD s3api get-bucket-encryption --bucket "$BUCKET_NAME" --query 'ServerSideEncryptionConfiguration.Rules[0].ApplyServerSideEncryptionByDefault.SSEAlgorithm' --output text 2>/dev/null || echo "None")
echo "Encryption: $ENCRYPTION"

# Check public access block
PUBLIC_BLOCK=$($AWS_CMD s3api get-public-access-block --bucket "$BUCKET_NAME" 2>/dev/null || echo "{}")
if [ "$PUBLIC_BLOCK" = "{}" ]; then
    echo "Public Access Blocking: ❌ NOT CONFIGURED"
    NEEDS_PUBLIC_BLOCK=true
else
    BLOCK_PUBLIC_ACLS=$(echo "$PUBLIC_BLOCK" | grep -o '"BlockPublicAcls": true' || echo "")
    IGNORE_PUBLIC_ACLS=$(echo "$PUBLIC_BLOCK" | grep -o '"IgnorePublicAcls": true' || echo "")
    BLOCK_PUBLIC_POLICY=$(echo "$PUBLIC_BLOCK" | grep -o '"BlockPublicPolicy": true' || echo "")
    RESTRICT_PUBLIC_BUCKETS=$(echo "$PUBLIC_BLOCK" | grep -o '"RestrictPublicBuckets": true' || echo "")

    if [ -n "$BLOCK_PUBLIC_ACLS" ] && [ -n "$IGNORE_PUBLIC_ACLS" ] && [ -n "$BLOCK_PUBLIC_POLICY" ] && [ -n "$RESTRICT_PUBLIC_BUCKETS" ]; then
        echo "Public Access Blocking: ✓ Fully configured"
        NEEDS_PUBLIC_BLOCK=false
    else
        echo "Public Access Blocking: ⚠ Partially configured"
        NEEDS_PUBLIC_BLOCK=true
    fi
fi

echo ""

# Apply hardening if needed
if [ "$NEEDS_PUBLIC_BLOCK" = true ]; then
    echo "Applying Security Hardening..."
    echo "------------------------------"

    echo "Blocking public access (all settings)..."
    if $AWS_CMD s3api put-public-access-block \
        --bucket "$BUCKET_NAME" \
        --public-access-block-configuration \
            "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"; then
        echo "✓ Public access blocking enabled"
    else
        echo "❌ Failed to enable public access blocking"
        exit 1
    fi

    echo ""
    echo "==================================================================="
    echo "✅ Security hardening complete!"
    echo "==================================================================="
else
    echo "==================================================================="
    echo "✅ All free security features are already configured!"
    echo "==================================================================="
fi

echo ""
echo "Current configuration:"
echo "  • Versioning: $VERSIONING"
echo "  • Encryption: $ENCRYPTION"
echo "  • Public Access: Fully blocked"
echo ""
echo "💰 Cost Impact: $0.00 (all free features)"
echo ""
