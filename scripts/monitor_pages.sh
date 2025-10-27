#!/bin/bash

# Script to monitor GitHub Pages status and enable HTTPS
# Usage: ./monitor_pages.sh [--timeout <minutes>]

set -euo pipefail

REPO="policyoftruth/policyoftruth.github.io"
TIMEOUT_MINUTES=60
CHECK_INTERVAL=60  # seconds between checks
TOTAL_CHECKS=$((TIMEOUT_MINUTES * 60 / CHECK_INTERVAL))

# Process command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --timeout)
            TIMEOUT_MINUTES="$2"
            TOTAL_CHECKS=$((TIMEOUT_MINUTES * 60 / CHECK_INTERVAL))
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--timeout <minutes>]"
            exit 1
            ;;
    esac
done

# Check if gh CLI is installed and authenticated
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed"
    echo "Install with: brew install gh"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "Error: Not authenticated with GitHub CLI"
    echo "Run: gh auth login"
    exit 1
fi

# Function to get pages status
get_pages_status() {
    gh api -H "Accept: application/vnd.github+json" "/repos/${REPO}/pages"
}

# Function to enable HTTPS
enable_https() {
    echo '{"https_enforced":true}' | \
    gh api --method PUT \
        -H "Accept: application/vnd.github+json" \
        "/repos/${REPO}/pages" \
        --input -
}

echo "Starting GitHub Pages monitor..."
echo "Will check every ${CHECK_INTERVAL} seconds for ${TIMEOUT_MINUTES} minutes"

count=0
while [ $count -lt $TOTAL_CHECKS ]; do
    count=$((count + 1))
    echo -n "Check $count of $TOTAL_CHECKS: "

    # Get current status
    if ! STATUS=$(get_pages_status); then
        echo "Failed to get Pages status"
        sleep $CHECK_INTERVAL
        continue
    fi

    # Extract relevant fields
    CURRENT_STATUS=$(echo "$STATUS" | jq -r '.status // ""')
    HTTPS_ENFORCED=$(echo "$STATUS" | jq -r '.https_enforced // false')
    DOMAIN_STATUS=$(echo "$STATUS" | jq -r '.protected_domain_state // ""')

    echo "Status: $CURRENT_STATUS, HTTPS Enforced: $HTTPS_ENFORCED, Domain: $DOMAIN_STATUS"

    # If HTTPS is already enforced, we're done
    if [ "$HTTPS_ENFORCED" = "true" ]; then
        echo "✅ HTTPS is enabled and enforced!"
        exit 0
    fi

    # Try to enable HTTPS if site is verified
    if [ "$CURRENT_STATUS" = "built" ] && [ "$DOMAIN_STATUS" = "verified" ]; then
        echo "Attempting to enable HTTPS..."
        if enable_https; then
            echo "✅ Successfully enabled HTTPS!"
            exit 0
        else
            echo "❌ Failed to enable HTTPS. Will retry..."
        fi
    fi

    # If we're still here, wait and try again
    echo "Waiting ${CHECK_INTERVAL} seconds before next check..."
    sleep $CHECK_INTERVAL
done

echo "❌ Timeout reached after ${TIMEOUT_MINUTES} minutes"
echo "Last status:"
get_pages_status | jq '.'
exit 1
