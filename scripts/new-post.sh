#!/bin/bash
# new-post.sh
# Simple script to create a new blog post entry

show_help() {
    cat << EOF

Usage: ./new-post.sh [TITLE]

This script creates a new blog post entry with the current timestamp.
It will:
1. Read the template from blog-template.html
2. Replace TITLE_HERE with your title
3. Replace DATE_HERE with the current timestamp
4. Copy the result to your clipboard (if xclip is available)
5. Save it to a temporary file
6. Then you can paste it at the top of the posts-container in index.html

Examples:
  ./new-post.sh "My New Blog Post"
  ./new-post.sh  (will prompt for title)

Options:
  -h, --help    Show this help message

EOF
}

# Check for help flag
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Get to the script's directory and then project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT" || exit 1

# Check if template exists
TEMPLATE_PATH="$PROJECT_ROOT/blog-template.html"
if [[ ! -f "$TEMPLATE_PATH" ]]; then
    echo -e "\033[0;31mError: blog-template.html not found!\033[0m"
    exit 1
fi

# Get title
if [[ -z "$1" ]]; then
    read -p "Enter blog post title: " TITLE
    if [[ -z "$TITLE" ]]; then
        echo -e "\033[0;31mError: Title cannot be empty!\033[0m"
        exit 1
    fi
else
    TITLE="$*"
fi

# Generate timestamp in your format (YYYY.MM.DD HH:MM:SS)
TIMESTAMP=$(date "+%Y.%m.%d %H:%M:%S")

# Read template
TEMPLATE=$(<"$TEMPLATE_PATH")

# Replace placeholders
NEW_POST="${TEMPLATE//TITLE_HERE/$TITLE}"
NEW_POST="${NEW_POST//DATE_HERE/$TIMESTAMP}"

# Save to temporary file
TEMP_FILE="/tmp/blog-post-$(date +%s).html"
echo "$NEW_POST" > "$TEMP_FILE"

# Try to copy to clipboard (works in WSL2 with clip.exe)
if command -v clip.exe &> /dev/null; then
    echo "$NEW_POST" | clip.exe
    CLIPBOARD_STATUS="✓ Copied to clipboard!"
elif command -v xclip &> /dev/null; then
    echo "$NEW_POST" | xclip -selection clipboard
    CLIPBOARD_STATUS="✓ Copied to clipboard!"
else
    CLIPBOARD_STATUS="⚠ Clipboard not available (install xclip or use clip.exe)"
fi

# Display success message
echo -e "\n\033[0;32mNew blog post created!\033[0m"
echo -e "\033[0;36mTitle: $TITLE\033[0m"
echo -e "\033[0;36mDate: $TIMESTAMP\033[0m"
echo -e "\n\033[0;33m$CLIPBOARD_STATUS\033[0m"
echo -e "\033[0;33mAlso saved to: $TEMP_FILE\033[0m"
echo -e "\n\033[0;37mNext steps:\033[0m"
echo "1. Open index.html in your editor"
echo "2. Find the <div id=\"posts-container\"> line"
echo "3. Paste the new post RIGHT AFTER that line (before other posts)"
echo "4. Edit the content between the <p> tags"
echo "5. Update the tags at the bottom"
echo "6. Save and commit!"
echo ""
echo -e "\033[0;90m# You can also cat the temp file:\033[0m"
echo -e "\033[0;90mcat $TEMP_FILE\033[0m"
echo ""
