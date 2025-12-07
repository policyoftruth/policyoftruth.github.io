# Project Overview

This is a personal blog hosted on GitHub Pages. The website is a static HTML page with a retro-futuristic, cyberpunk-inspired theme. The content is manually added to the `index.html` file. The infrastructure for the custom domain and DNS is managed using Terragrunt and Terraform.

# Building and Running

The website is a static site, so there is no build process. To view the site, simply open the `index.html` file in a web browser.

The infrastructure is managed by Terragrunt. The following commands can be used to manage the infrastructure:

*   `terragrunt run-all plan`:  Show a plan of all infrastructure changes.
*   `terragrunt run-all apply`: Apply all infrastructure changes.

# Development Conventions

New blog posts are created by running the `scripts/new-post.sh` script. This script takes a title as an argument and generates a new blog post entry with the current timestamp. The new post is then manually pasted into the `index.html` file.

The script uses a template file, `blog-template.html`, to generate the new post. To modify the structure of new posts, edit this file.
