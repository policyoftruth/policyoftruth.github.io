## **rando notes**

### **get name servers**
`HZC=$(aws route53 list-hosted-zones | jq -r '.HostedZones[] | select(.Name=="k8s.winningham.me.") | .Id' | tee /dev/stderr)`

`aws route53 get-hosted-zone --id $HZC | jq .DelegationSet.NameServers`
