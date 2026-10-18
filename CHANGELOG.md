# Changelog

All notable changes to this project are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
the versioning follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

| Part | Raised when |
|---|---|
| **MAJOR** | existing CI jobs can break — a tool is removed or replaced |
| **MINOR** | a tool is added |
| **PATCH** | a rebuild with updated packages or a fix |

**A release is a git tag `X.Y.Z`.** CI builds `X.Y.Z`, `X.Y` and `X` from it, moves `latest` and creates the GitHub
release from the entry below. Each release entry names the contained versions of the main tools and Alpine. The weekly
`latest` builds are not listed here.

## [1.1.0] - 2026-10-18

### Contents

- Vault `2.2.0`, kubectl `1.36.1`, Helm `3.19.0`, AWS CLI `2.34.63`
- Docker CLI `29.8.2`, Docker Compose `5.1.4`, git `2.54.0`, Alpine `3.24.2`

### Added

- `linux/arm64` next to `linux/amd64` for every tag. Each platform is built and tested on its own before the push,
  and Vault is the release for the respective platform

## [1.0.0] - 2026-10-18

### Contents

- Vault `2.2.0`, kubectl `1.36.1`, Helm `3.19.0`, AWS CLI `2.34.63`
- Docker CLI `29.8.2`, Docker Compose `5.1.4`, git `2.54.0`, Alpine `3.24.2`

### Added

- Releases from git tags `X.Y.Z` with the image tags `X.Y.Z`, `X.Y` and `X`, and a GitHub release from this changelog
- A mirror on GitHub: `github.com/epicsoft-llc/ci`

### Security

- Vault is checked against the SHA-256 sums HashiCorp publishes for the release before it is unpacked
- The packages of the base image are upgraded as well (`apk upgrade`). The image held OpenSSL `3.5.8` from
  `alpine:latest`, although Alpine `3.24` already offered `3.5.9`, a security release whose most severe fix is rated
  High
- Registry logins and the Docker Hub description upload take their tokens over stdin or the environment instead of the
  command line

### Changed

- The image is tested before it is pushed: every tool has to start
- Vault is downloaded for the platform of the build instead of always `linux_amd64`
- Image labels: the version comes from the tag, the maintainer address is `info@epicsoft.one`
