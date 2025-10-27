# GitHub static site with Route53 DNS via Terragrunt

## **Manual steps**
- Purchase route53 domain name
- Create s3 bucket for state
- Configure/run Terragrunt
- Update domain reg with your nameservers from tf outputs

## **Commands**
- `terragrunt run --all plan`

## **ToDo**
- Pipeline with github actions

## **Resources**
- <https://docs.github.com/en/github/working-with-github-pages/configuring-a-custom-domain-for-your-github-pages-site>
- <https://docs.github.com/en/github/working-with-github-pages/troubleshooting-custom-domains-and-github-pages#cname-errors>
