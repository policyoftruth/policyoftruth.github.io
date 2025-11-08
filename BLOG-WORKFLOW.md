# Blog Workflow Guide

## Quick Start

### Creating a New Blog Post

1. **Run the script:**
   ```bash
   ./scripts/new-post.sh "Your Post Title"
   ```
   
   Or just run it without parameters and it will prompt you:
   ```bash
   ./scripts/new-post.sh
   ```

2. **The script will:**
   - Generate a timestamp in your format (YYYY.MM.DD HH:MM:SS)
   - Create a blog post from the template
   - Copy it to your clipboard automatically (using WSL2's clip.exe)
   - Save it to a temporary file as backup

3. **Paste and edit:**
   - Open `index.html` in your editor
   - Find the line: `<div id="posts-container">`
   - Paste the new post **right after** that line (before existing posts)
   - Edit the content between the `<p>` tags
   - Update the tags to match your post

4. **Commit and push:**
   ```bash
   git add index.html
   git commit -m "New post: Your Post Title"
   git push
   ```

## Manual Method (Without Script)

If you prefer to do it manually:

1. **Open `blog-template.html`** and copy the entire contents

2. **Replace the placeholders:**
   - `TITLE_HERE` → Your post title
   - `DATE_HERE` → Current date/time in format: `2025.10.28 22:22:22`

3. **Paste at the top** of the posts-container in `index.html`

4. **Edit content and tags**

5. **Save and commit**

## Template Customization

The `blog-template.html` file contains:
- Basic paragraph structure
- Example code block
- Example link
- Tag placeholders

Feel free to modify the template to match your most common post structure!

## Tips

- **New posts go first**: Always paste new posts at the top (right after `<div id="posts-container">`)
- **10 posts per page**: The site automatically paginates after 10 posts
- **Consistent formatting**: Use the template to maintain consistent structure
- **Tags**: Update the tags to be relevant - remove unused ones, add more as needed
- **Code blocks**: Use `<pre><code>` for terminal commands or code snippets
- **Links**: Use `target="_blank"` for external links
- **Temp files**: The script saves to `/tmp/blog-post-*.html` as backup

## Date Format

Your site uses: `YYYY.MM.DD HH:MM:SS`

Examples:
- `2025.10.28 00:00:01`
- `2025.12.31 23:59:59`

The bash script handles this automatically!

## Clipboard in WSL2

The script automatically detects and uses `clip.exe` (Windows clipboard) in WSL2.
If you're not in WSL2, it will try to use `xclip` if available.

To install xclip (if needed):
```bash
sudo apt-get install xclip
```

## Script Options

```bash
./scripts/new-post.sh -h          # Show help
./scripts/new-post.sh --help      # Show help
./scripts/new-post.sh "Title"     # Create post with title
./scripts/new-post.sh             # Prompt for title
```
