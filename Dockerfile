#### https://hub.docker.com/_/alpine
ARG ALPINE_VERSION=latest

#### HashiCorp Vault - the newest release for the target platform, checked against its published SHA-256 sums
FROM alpine:${ALPINE_VERSION} AS vault-stage
ARG TARGETARCH
WORKDIR /vault
RUN apk --no-cache add curl jq unzip
RUN VERSION=$(curl -fsS https://api.github.com/repos/hashicorp/vault/releases/latest | jq -r '.tag_name' | sed 's/^v//') \
 && curl -fsSO "https://releases.hashicorp.com/vault/${VERSION}/vault_${VERSION}_linux_${TARGETARCH}.zip" \
 && curl -fsSO "https://releases.hashicorp.com/vault/${VERSION}/vault_${VERSION}_SHA256SUMS" \
 && grep " vault_${VERSION}_linux_${TARGETARCH}.zip$" "vault_${VERSION}_SHA256SUMS" | sha256sum -c - \
 && unzip "vault_${VERSION}_linux_${TARGETARCH}.zip" -d /usr/local/bin

#### CI/CD Tools image
FROM alpine:${ALPINE_VERSION}

ARG IMAGE_TAG="local"
ARG BUILD_DATE="development"
LABEL org.label-schema.name="CI/CD Tools" \
      org.label-schema.description="CI/CD tool collection on Alpine - Vault, kubectl, Helm, AWS CLI, Docker CLI and more" \
      org.label-schema.vendor="epicsoft LLC / Alexander Schwarz <info@epicsoft.one>" \
      org.label-schema.version=${IMAGE_TAG} \
      org.label-schema.schema-version="1.0" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.url="https://gitlab.com/epicsoft-networks/ci" \
      org.label-schema.vcs-url="https://gitlab.com/epicsoft-networks/ci/-/tree/main"

LABEL image.name="epicsoft_ci_cd" \
      image.description="CI/CD tool collection on Alpine - Vault, kubectl, Helm, AWS CLI, Docker CLI and more" \
      maintainer="epicsoft LLC" \
      maintainer.name="Alexander Schwarz <info@epicsoft.one>" \
      maintainer.copyright="Copyright 2023-2026 epicsoft LLC / Alexander Schwarz" \
      license="MIT"

#### packages of the base image lag behind the Alpine repository - the upgrade brings their security fixes
RUN apk --no-cache upgrade \
 && apk --no-cache add bash \
                       ca-certificates \
                       curl \
                       docker-cli \
                       docker-cli-compose \
                       gettext \
                       git \
                       helm \
                       jq \
                       kubectl \
                       lftp \
                       mariadb-client \
                       mysql-client \
                       openssh-client-default \
                       outils-sha256 \
                       p7zip \
                       rsync \
                       sshpass \
                       tzdata \
                       unzip \
                       wget \
                       yq \
                       aws-cli \
 && update-ca-certificates \
 && rm -rf /var/cache/apk/*

COPY --from=vault-stage /usr/local/bin/vault /usr/local/bin/vault
RUN chmod 755 /usr/local/bin/vault
