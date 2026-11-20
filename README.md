# CI/CD Tools

This Docker image is managed and kept up to date by [epicsoft LLC](https://epicsoft.one).

The tools CI/CD jobs need again and again, in one image on the official [Alpine image](https://hub.docker.com/_/alpine):
HashiCorp Vault, kubectl, Helm, the AWS CLI, the Docker CLI with Compose, Cloudflare Wrangler with Node.js, Python 3,
git and more.

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
| `1.2.0` | exactly this build - **use this in production** |
| `1.2`, `1` | newest release of that line |
| `latest` | the `main` branch, rebuilt weekly on `alpine:latest`, also moved by every release |

`1.2.0` contains Vault `2.2.2`, kubectl `1.36.1`, Helm `3.22.1`, AWS CLI `2.34.63`, Docker CLI `29.9.3`, Docker Compose
`5.7.2`, git `2.54.1`, Node.js `24.22.3`, Wrangler `4.165.0`, Python `3.14.10` and Alpine `3.24.4`.

## Tools

### From the Alpine packages

Every tool that Alpine maintains comes from the Alpine packages - https://pkgs.alpinelinux.org/packages

- aws-cli
- bash
- curl
- docker-cli
- docker-cli-compose
- gettext
- git
- jq
- kubectl
- lftp
- mariadb-client
- mysql-client
- nodejs
- npm
- openssh-client-default
- outils-sha256
- p7zip
- python3
- rsync
- sed (GNU sed)
- sshpass
- tzdata
- unzip
- wget
- yq

### Installed in addition

Only what Alpine does not package or does not keep up to date. Vault and Helm are checked against the SHA-256 sums their
projects publish, Wrangler against the integrity hashes and signatures of the npm registry:

- vault - https://www.vaultproject.io/ - the newest release from `releases.hashicorp.com`; Vault is not in the Alpine
  packages
- helm - https://helm.sh/ - the newest Helm 3 from `get.helm.sh`; the Alpine package has stalled at `3.19.0`, and
  Helm 4 changes commands
- wrangler - https://developers.cloudflare.com/workers/wrangler/ - the newest release from npm, verified with
  `npm audit signatures`; telemetry is off (`WRANGLER_SEND_METRICS=false`)

## Example

`.gitlab-ci.yml`

```yml
deploy:
  image: epicsoft/ci:1.2
  script:
    - kubectl version --client
    - helm version --short
    - wrangler pages deploy public --project-name=my-site --branch=main
```

## Reporting problems

Issues are welcome on [GitLab](https://gitlab.com/epicsoft-networks/ci/-/issues) and
[GitHub](https://github.com/epicsoft-llc/ci/issues). Please report a security problem as a
**confidential issue** on GitLab instead of a public one.

## License

[MIT](https://gitlab.com/epicsoft-networks/ci/-/blob/main/LICENSE) — Copyright (c) 2023-2026 epicsoft LLC / Alexander Schwarz

The MIT license applies only to files created by epicsoft LLC. Third-party software in the image — the tools listed
above, the Alpine packages and the official `alpine` image — remains under its own licenses.
