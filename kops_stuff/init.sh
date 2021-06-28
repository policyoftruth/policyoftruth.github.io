#!/bin/bash

### fetch old ass kops
export KOPS_VERSION=1.11.1
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$KOPS_VERSION/kops-darwin-amd64
chmod +x kops

### fetch old ass kubectl
export KUBECTL_VERSION=v1.11.10
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/darwin/amd64/kubectl
chmod +x kubectl
