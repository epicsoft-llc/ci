FROM alpine:latest

ARG BUILD_DATE="development"
LABEL org.label-schema.name="CI Tools" \
      org.label-schema.description="A tool collection to run in the CI based on Alpine Linux" \
      org.label-schema.vendor="epicsoft LLC / Alexander Schwarz <as@epicsoft.one>" \
      org.label-schema.version="latest" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.url="https://gitlab.com/epicsoft-networks/ci" \
      org.label-schema.vcs-url="https://gitlab.com/epicsoft-networks/ci/tree/main"

LABEL image.name="epicsoft_ci" \
      image.description="A tool collection to run in the CI based on Alpine Linux" \
      maintainer="epicsoft LLC" \
      maintainer.name="Alexander Schwarz <as@epicsoft.one>" \
      maintainer.copyright="Copyright 2023 epicsoft LLC / Alexander Schwarz" \
      license="MIT"

RUN apk --no-cache add lftp \
                       gettext \
                       aws-cli \
                       p7zip \
                       rsync \
                       openssh-client-default \
                       sshpass \
                       tzdata \
                       mysql-client \
                       mariadb-client \
                       git \
                       ca-certificates \
 && update-ca-certificates \
 && rm -rf /var/cache/apk/*
