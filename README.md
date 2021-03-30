# gh pages site w/route53 dns via tf

## **manual steps**
1. purchase route53 domain name
1. create s3 bucket for tf state
1. configure/run tf 
1. update domain reg with your nameservers from tf outputs

## **todo**
1. encrypted state
1. template backend.conf because can't variablize
1. pipeline with github actions

## **resources**
1. <https://docs.github.com/en/github/working-with-github-pages/configuring-a-custom-domain-for-your-github-pages-site>
1. <https://docs.github.com/en/github/working-with-github-pages/troubleshooting-custom-domains-and-github-pages#cname-errors>
