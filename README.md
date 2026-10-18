# CI/CD Tools

This Docker image is managed and kept up to date by [epicsoft LLC](https://epicsoft.one).

The tools CI/CD jobs need again and again, in one image on the official [Alpine image](https://hub.docker.com/_/alpine):
HashiCorp Vault, kubectl, Helm, the AWS CLI, the Docker CLI with Compose, git and more.

* Base image: https://hub.docker.com/_/alpine, platforms `linux/amd64` and `linux/arm64`
* Dockerfile: https://gitlab.com/epicsoft-networks/ci/-/blob/main/Dockerfile
* Repository: https://gitlab.com/epicsoft-networks/ci, mirrored to [GitHub](https://github.com/epicsoft-llc/ci) — issues are welcome on both; code changes only as merge requests on GitLab, the mirror overwrites anything pushed to GitHub
* Container registry: https://gitlab.com/epicsoft-networks/ci/container_registry
* Docker Hub: https://hub.docker.com/r/epicsoft/ci
* Changelog: https://gitlab.com/epicsoft-networks/ci/-/blob/main/CHANGELOG.md
* License: MIT

## Versions

Released through a git tag `X.Y.Z`, which publishes `X.Y.Z`, `X.Y` and `X` and moves `latest`. Changes and the
contained versions are listed in the [changelog](https://gitlab.com/epicsoft-networks/ci/-/blob/main/CHANGELOG.md).

| Tag | Content |
|---|---|
| `1.1.0` | exactly this build - **use this in production** |
| `1.1`, `1` | newest release of that line |
| `latest` | the `main` branch, rebuilt weekly on `alpine:latest`, also moved by every release |

`1.1.0` contains Vault `2.2.0`, kubectl `1.36.1`, Helm `3.19.0`, AWS CLI `2.34.63`, Docker CLI `29.8.2`, Docker Compose
`5.1.4`, git `2.54.0` and Alpine `3.24.2`.

## Tools

### From the Alpine packages

Alpine packages - https://pkgs.alpinelinux.org/packages

- aws-cli
- bash
- curl
- docker-cli
- docker-cli-compose
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
- wget
- yq

### Installed in addition

- vault - https://www.vaultproject.io/ - the newest release from `releases.hashicorp.com`, checked against the SHA-256
  sums HashiCorp publishes for it

## Example

`.gitlab-ci.yml`

```yml
deploy:
  image: epicsoft/ci:1.1
  script:
    - kubectl version --client
    - helm version --short
```

## Reporting problems

Issues are welcome on [GitLab](https://gitlab.com/epicsoft-networks/ci/-/issues) and
[GitHub](https://github.com/epicsoft-llc/ci/issues). Please report a security problem as a
**confidential issue** on GitLab instead of a public one.

## License

[MIT](https://gitlab.com/epicsoft-networks/ci/-/blob/main/LICENSE) — Copyright (c) 2023-2026 epicsoft LLC / Alexander Schwarz

The MIT license applies only to files created by epicsoft LLC. Third-party software in the image — the tools listed
above, the Alpine packages and the official `alpine` image — remains under its own licenses.
