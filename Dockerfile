#### HashiCorp Vault Stage
FROM alpine:latest as vault-stage
WORKDIR /
RUN apk --no-cache add curl wget jq sed unzip
RUN export LATEST=$(curl -s https://api.github.com/repos/hashicorp/vault/releases/latest | jq -r '.name' | sed 's:v::g') \
 && wget -q -O vault.zip https://releases.hashicorp.com/vault/${LATEST}/vault_${LATEST}_linux_amd64.zip \
 && unzip vault.zip -d /

#### CI/CD Tools image
FROM alpine:latest

ARG BUILD_DATE="development"
LABEL org.label-schema.name="CI/CD Tools" \
      org.label-schema.description="A tool collection to run in the CI/CD based on official Alpine image" \
      org.label-schema.vendor="epicsoft LLC / Alexander Schwarz <as@epicsoft.one>" \
      org.label-schema.version="latest" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.url="https://gitlab.com/epicsoft-networks/ci" \
      org.label-schema.vcs-url="https://gitlab.com/epicsoft-networks/ci/tree/main"

LABEL image.name="epicsoft_ci_cd" \
      image.description="A tool collection to run in the CI/CD based on official Alpine image" \
      maintainer="epicsoft LLC" \
      maintainer.name="Alexander Schwarz <as@epicsoft.one>" \
      maintainer.copyright="Copyright 2023-2024 epicsoft LLC / Alexander Schwarz" \
      license="MIT"

RUN apk --no-cache add aws-cli \
                       ca-certificates \
                       curl \
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
                       yq \
 && update-ca-certificates \
 && rm -rf /var/cache/apk/*

COPY --from=vault-stage /vault /usr/local/bin/vault

RUN chmod 755 /usr/local/bin/vault
