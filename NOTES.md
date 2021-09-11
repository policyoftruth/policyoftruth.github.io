# notes

1. <https://kops.sigs.k8s.io/getting_started/aws/>

```
export NAME=bingo.k8s.winningham.me
export KOPS_STATE_STORE=s3://two-states-kops

kops create cluster \
    --zones=us-east-1a \
    ${NAME}
```
