# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.241.1/containers/debian/.devcontainer/base.Dockerfile

# [Choice] Debian version (use bullseye on local arm64/Apple Silicon): bullseye, buster
ARG VARIANT="bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

ENV DEBIAN_FRONTEND=noninteractive
# RUN apt-get update && sudo apt-get install -y gnupg software-properties-common
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
        https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/hashicorp.list

RUN apt-get update && apt-get -y install --no-install-recommends terraform 
RUN curl -sSL https://sdk.cloud.google.com | bash