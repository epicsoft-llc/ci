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

## [1.2.0] - 2026-11-20

### Contents

- Vault `2.2.2`, kubectl `1.36.1`, Helm `3.22.1`, AWS CLI `2.34.63`
- Docker CLI `29.9.3`, Docker Compose `5.7.2`, git `2.54.1`, Alpine `3.24.4`
- Node.js `24.22.3`, npm `11.12.1`, Wrangler `4.165.0`, Python `3.14.10`, GNU sed `4.9`

### Added

- Cloudflare Wrangler for deployments to Cloudflare Workers and Pages - the newest release from npm, verified with
  `npm audit signatures`; telemetry is off (`WRANGLER_SEND_METRICS=false`)
- Node.js and npm from the Alpine packages, which Wrangler runs on
- Python 3 and GNU sed from the Alpine packages; GNU sed replaces the BusyBox `sed` and brings options such as `-z`

## [1.1.1] - 2026-11-03

### Contents

- Vault `2.2.1`, kubectl `1.36.1`, Helm `3.22.1`, AWS CLI `2.34.63`
- Docker CLI `29.9.2`, Docker Compose `5.6.1`, git `2.54.0`, Alpine `3.24.3`

### Security

- Vault `2.2.1`, built with Go `1.27.3` for CVE-2026-111943
- curl `8.23.0` with 24 fixes, among them CVE-2026-92392, rated High by curl
- musl `1.2.6-r3` (CVE-2026-107891), expat `2.10.0` (CVE-2026-113351, CVE-2026-115506, CVE-2026-117610,
  CVE-2026-118370), brotli `1.2.1` (CVE-2026-111497)
- The MariaDB client `11.8.9`, Docker CLI `29.9.2` and Docker Compose `5.6.1` with their security fixes; Python
  `3.14.10`, c-ares `1.34.9`, ca-certificates `20261020` and Alpine `3.24.3`

## [1.1.0] - 2026-10-18

### Contents

- Vault `2.2.0`, kubectl `1.36.1`, Helm `3.22.1`, AWS CLI `2.34.63`
- Docker CLI `29.8.2`, Docker Compose `5.1.4`, git `2.54.0`, Alpine `3.24.2`

### Added

- `linux/arm64` next to `linux/amd64` for every tag. Each platform is built and tested on its own before the push,
  and Vault is the release for the respective platform

### Changed

- Helm comes from its project's releases - the newest Helm 3, checked against the published SHA-256 sum - instead of
  the Alpine package, which has stalled at `3.19.0` with a security upgrade pending. Helm 4 is left out on purpose: it
  changes commands. All other tools stay with the Alpine packages, which keep them maintained

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
