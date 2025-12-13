# Policy of Truth (policyoftruth.github.io)

This repository contains the source code for my personal static website hosted on GitHub Pages, as well as the Infrastructure as Code (IaC) configuration for managing the DNS records.

## Project Structure

The project is divided into two main components:

1.  **Static Site**: The content of the website itself.
    -   `index.html`: Main entry point.
    -   `style.css`: Styling for the site.
    -   `blog-template.html`: Template for blog posts.
    -   `scripts/`: Utility scripts.
    -   `CNAME`: Custom domain configuration for GitHub Pages.

2.  **Infrastructure**: DNS management for the domain.
    -   `route53/`: Terragrunt configuration for AWS Route53.
    -   `root.hcl`: Root Terragrunt configuration.

## Infrastructure Status

**Note:** The Terragrunt/OpenTofu parts for infrastructure provisioning are **completed locally**. The current DNS configuration is deployed and active.

The rest of the configuration in this repository pertains to the static GitHub Pages site functionality.

## Usage

### Static Site
You can edit the HTML and CSS files directly. Changes pushed to the `main` branch are automatically deployed by GitHub Pages.

### Infrastructure (Local)
Infrastructure changes are managed locally using Terragrunt.

Commands for reference:
- `terragrunt run-all plan`: Check for changes.
- `terragrunt run-all apply`: Apply changes.

## Development Notes

### DNS Configuration
Original nameservers setup (Reference):
```bash
source local.env && aws route53domains update-domain-nameservers \
  --domain-name winningham.me \
  --nameservers \
    Name=ns-1499.awsdns-59.org \
    Name=ns-791.awsdns-34.net \
    Name=ns-172.awsdns-21.com \
    Name=ns-1909.awsdns-46.co.uk
```

### Future Improvements
- [ ] Implement GitHub Actions pipeline for infrastructure (currently local).
- [ ] Rotate to IAM roles with OIDC integration.
