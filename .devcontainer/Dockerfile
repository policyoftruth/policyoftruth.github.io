# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.187.0/containers/alpine/.devcontainer/base.Dockerfile

### image pull
ARG VARIANT="3.13"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-alpine-${VARIANT}

### apk ops
RUN apk update && apk upgrade && \
    apk add --no-cache python3 py3-pip gcc make go && \
    rm -rf /var/cache/apk/*

### download and install terraform
ENV TERRAFORM_VERSION=1.0.5
ENV TERRAFORM_SHA256SUM=7ce24478859ab7ca0ba4d8c9c12bb345f52e8efdc42fa3ef9dd30033dbf4b561
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -c terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d . && \
    mv terraform /usr/bin/terraform && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip


### download and install terragrunt
ENV TERRAGRUNT_VERSION=0.31.7
ENV TERRAGRUNT_SHA256SUM=c1d863e8fa1c994a79338b28ec72dd97a97cff5d485691832c7304b43886a929
RUN curl -L --output ./terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    echo "${TERRAGRUNT_SHA256SUM}  ./terragrunt" > terragrunt-${TERRAGRUNT_VERSION}_SHA256SUMS && \
    sha256sum -c terragrunt-${TERRAGRUNT_VERSION}_SHA256SUMS && \
    chmod +x ./terragrunt && \
    mv ./terragrunt /usr/bin/terragrunt
