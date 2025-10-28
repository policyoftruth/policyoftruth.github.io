# GitHub static site with Route53 DNS via Terragrunt

## **Manual steps**
- Purchase route53 domain name
- Create s3 bucket for state
- Configure/run Terragrunt
- Update domain reg with your nameservers from tf outputs

## **Commands**
- `terragrunt run --all plan`

## **Notes**
```
17:37:59.284 STDOUT [route53] tofu: ns_output = tolist([
17:37:59.284 STDOUT [route53] tofu:   "ns-1499.awsdns-59.org",
17:37:59.284 STDOUT [route53] tofu:   "ns-172.awsdns-21.com",
17:37:59.284 STDOUT [route53] tofu:   "ns-1909.awsdns-46.co.uk",
17:37:59.284 STDOUT [route53] tofu:   "ns-791.awsdns-34.net",
17:37:59.284 STDOUT [route53] tofu: ])
```

Take these from the `terragrunt` output and update your AWS registrar DNS as listed:
```
source local.env && aws route53domains update-domain-nameservers \
  --domain-name winningham.me \
  --nameservers \
    Name=ns-1499.awsdns-59.org \
    Name=ns-791.awsdns-34.net \
    Name=ns-172.awsdns-21.com \
    Name=ns-1909.awsdns-46.co.uk
```

## **Security**

⚠️ **See [SECURITY.md](SECURITY.md) for complete security checklist**

### Immediate Actions Required
1. **Rotate AWS credentials** (exposed credentials need rotation)
2. **Harden S3 backend**: `source local.env && ./scripts/harden_existing_backend.sh`
3. **Enable HTTPS** on GitHub Pages after DNS validation

### Current Security Status
- ✅ S3 encryption enabled
- ✅ S3 versioning enabled  
- ✅ TLS-only bucket policy
- ⚠️ Need to add public access blocking (run hardening script)
- ⚠️ Need to rotate AWS credentials

**Cost Impact**: $0.00 (all recommended improvements are free)

## **ToDo**
- Pipeline with github actions
- Rotate to IAM roles with OIDC (remove long-lived credentials)

## **Resources**
- <https://docs.github.com/en/github/working-with-github-pages/configuring-a-custom-domain-for-your-github-pages-site>
- <https://docs.github.com/en/github/working-with-github-pages/troubleshooting-custom-domains-and-github-pages#cname-errors>
