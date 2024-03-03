# CI/CD Tools

This Docker image is managed and kept up to date by [epicsoft LLC](https://epicsoft.one).

A tool collection to run in the CI/CD based on official [Alpine](https://hub.docker.com/_/alpine) image.

* Base image: https://hub.docker.com/_/alpine
* Dockerfile: https://gitlab.com/epicsoft-networks/ci/blob/main/Dockerfile
* Repository: https://gitlab.com/epicsoft-networks/ci/tree/main
* Container-Registry: https://gitlab.com/epicsoft-networks/ci/container_registry
* Docker Hub: https://hub.docker.com/r/epicsoft/ci

## Versions

`latest`  
based on `alpine:latest` image - build `weekly`

## Tools

There are some tools installed in this image that are often and less often needed in a CI/CD

### Installed applications from officially Alpine packages 

Alpine packages - https://pkgs.alpinelinux.org/packages

- aws-cli
- bash
- curl
- gettext
- git
- helm
- jq
- kubectl
- lftp
- mariadb-client
- mysql-client
- openssh-client-default
- outils-sha256
- p7zip
- rsync
- sshpass
- tzdata
- unzip
- yq

### Additionally installed applications

- vault - https://www.vaultproject.io/

## License

MIT License see [LICENSE](https://gitlab.com/epicsoft-networks/ci/blob/main/LICENSE)

Please note that the MIT license only applies to the files created by epicsoft LLC. Other software may be licensed under other licenses.
