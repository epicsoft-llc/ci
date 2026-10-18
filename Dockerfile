#### https://hub.docker.com/_/alpine
ARG ALPINE_VERSION=latest

#### Only tools Alpine does not package or does not keep up to date - the newest release for the target platform,
#### checked against the SHA-256 sums its project publishes. Everything Alpine maintains comes from its packages.
FROM alpine:${ALPINE_VERSION} AS download-stage
ARG TARGETARCH
WORKDIR /download
RUN apk --no-cache add curl jq unzip

#### https://releases.hashicorp.com/vault/ - Vault is not in the Alpine packages
RUN VERSION=$(curl -fsS https://api.github.com/repos/hashicorp/vault/releases/latest | jq -r '.tag_name' | sed 's/^v//') \
 && curl -fsSO "https://releases.hashicorp.com/vault/${VERSION}/vault_${VERSION}_linux_${TARGETARCH}.zip" \
 && curl -fsSO "https://releases.hashicorp.com/vault/${VERSION}/vault_${VERSION}_SHA256SUMS" \
 && grep " vault_${VERSION}_linux_${TARGETARCH}.zip$" "vault_${VERSION}_SHA256SUMS" | sha256sum -c - \
 && unzip "vault_${VERSION}_linux_${TARGETARCH}.zip" -d vault \
 && install -m 755 vault/vault /usr/local/bin/vault \
 && install -D -m 644 vault/LICENSE.txt /usr/local/share/licenses/vault/LICENSE.txt

#### https://github.com/helm/helm/releases - the newest Helm 3 (Helm 4 changes commands); Alpine's helm has stalled
#### at 3.19.0, its security upgrade has been a draft since 2026-05
RUN VERSION=$(curl -fsS "https://api.github.com/repos/helm/helm/releases?per_page=100" \
      | jq -r '[.[] | select(.prerelease | not) | .tag_name | select(startswith("v3."))] | sort_by(ltrimstr("v") | split(".") | map(tonumber)) | last') \
 && curl -fsSO "https://get.helm.sh/helm-${VERSION}-linux-${TARGETARCH}.tar.gz" \
 && echo "$(curl -fsSL "https://get.helm.sh/helm-${VERSION}-linux-${TARGETARCH}.tar.gz.sha256sum" | cut -d' ' -f1)  helm-${VERSION}-linux-${TARGETARCH}.tar.gz" | sha256sum -c - \
 && tar -xzf "helm-${VERSION}-linux-${TARGETARCH}.tar.gz" \
 && install -m 755 "linux-${TARGETARCH}/helm" /usr/local/bin/helm

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

COPY --from=download-stage /usr/local/bin/ /usr/local/bin/
COPY --from=download-stage /usr/local/share/licenses/ /usr/local/share/licenses/
