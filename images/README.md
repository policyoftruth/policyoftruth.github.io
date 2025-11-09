# Image Directory

This directory contains all images used in blog posts.

## How to Add Images to Blog Posts

### 1. Add Your Image File

Place your image file in this `images/` directory:

```bash
# Example: copy an image here
cp ~/Downloads/my-screenshot.png images/
```

### 2. Use in Your Blog Post

There are several ways to include images in your posts:

#### A. Simple Full-Width Image

```html
<img src="images/my-screenshot.png" alt="Description of the image">
```

#### B. Image with Caption

```html
<div class="img-container">
    <img src="images/my-screenshot.png" alt="Description of the image">
    <p class="img-caption">This is a caption explaining the image</p>
</div>
```

#### C. Inline Image (Floated Right)

```html
<img src="images/my-screenshot.png" alt="Description" class="img-inline">
<p>
    Your text will wrap around this image on the left side.
    Good for smaller images that complement your text.
</p>
```

#### D. Inline Image (Floated Left)

```html
<img src="images/my-screenshot.png" alt="Description" class="img-inline-left">
<p>
    Your text will wrap around this image on the right side.
</p>
```

## Best Practices

### File Names
- Use descriptive, lowercase names
- Use hyphens instead of spaces: `my-cool-screenshot.png`
- Include date if helpful: `2025-11-08-setup.png`

### File Formats
- **PNG**: Screenshots, graphics with transparency, diagrams
- **JPG**: Photos, complex images
- **GIF**: Simple animations (use sparingly)
- **WebP**: Modern format, smaller file sizes (if your audience supports it)

### File Sizes
- Keep images under 500KB when possible
- Optimize before uploading:
  - Use tools like `imagemagick`, `optipng`, or online services
  - Example: `convert input.png -quality 85 -resize 1200x output.png`

### Accessibility
- **Always include alt text** describing the image
- Alt text helps screen readers and shows when images don't load
- Be descriptive: "Terminal showing successful git push" not "screenshot"

### Organization (Optional)
You can organize by year/month if you have many images:

```
images/
├── 2025/
│   ├── 10/
│   │   └── first-post-diagram.png
│   └── 11/
│       └── setup-screenshot.png
└── README.md
```

Then reference as: `images/2025/11/setup-screenshot.png`

## Examples from Your Posts

```html
<!-- Terminal screenshot -->
<img src="images/zed-editor-screenshot.png" alt="Zed editor showing blog post editing">

<!-- With caption -->
<div class="img-container">
    <img src="images/minimal-setup.png" alt="Minimalist development setup">
    <p class="img-caption">My minimal web development workflow</p>
</div>

<!-- Small inline image -->
<img src="images/logo.png" alt="Project logo" class="img-inline">
<p>
    This is my project logo. It's small and floats to the right
    while text wraps around it nicely. Perfect for small visual
    elements that complement your writing.
</p>
```

## Commit Images to Git

Don't forget to add and commit your images:

```bash
git add images/my-new-image.png
git commit -m "Add image for blog post"
git push
```

## The Theme

Images will automatically get:
- ✅ Green border matching your terminal theme
- ✅ Glow effect on hover
- ✅ Responsive sizing (fits mobile screens)
- ✅ Proper spacing above and below

The styling matches your site's aesthetic perfectly!