# AGENTS.md

Guidance for AI coding agents and contributors working in this repository.

## What this repository is

There is no application source here. The repo produces the `epicsoft/ci` Docker image: the tools CI/CD jobs need, on
the official `alpine` image. Everything is one Dockerfile and a GitLab CI pipeline; `README.md` is the published Docker
Hub description and is uploaded by the pipeline, so it is part of the release artifact, not just documentation.

| | |
|---|---|
| **Repository** | developed on `gitlab.com/epicsoft-networks/ci` (branch `main`), mirrored to `github.com/epicsoft-llc/ci` |
| **Registries** | `registry.gitlab.com/epicsoft-networks/ci` and Docker Hub `epicsoft/ci` |
| **Platforms** | `linux/amd64` (`BUILD_PLATFORMS` in `.gitlab-ci.yml`) |

The Dockerfile has two stages. `vault-stage` downloads the newest HashiCorp Vault release for `TARGETARCH` and checks it
against the `SHA256SUMS` file of that release before unpacking — Vault is not in the Alpine packages. The final stage
installs everything else from the Alpine packages, after `apk --no-cache upgrade`.

## Tags

| Tags | Built from | Content |
|---|---|---|
| `latest` | branch `main` (push, weekly schedule) and every release | `alpine:latest` with the newest packages |
| `X.Y.Z`, `X.Y`, `X` | a git tag `X.Y.Z` | frozen at release time — the tags a CI job should pin |

A release also moves `latest`. Versioning follows Semantic Versioning; the rules are at the top of `CHANGELOG.md`.

## Pipeline structure (`.gitlab-ci.yml`)

| Job | Trigger | Action |
|---|---|---|
| `latest` | branch `main` (push, weekly schedule) | build and test every platform, push `latest` to both registries |
| `release` | tag `X.Y.Z` | fails unless `CHANGELOG.md` has `## [X.Y.Z] - <date>`; same build, pushes `X.Y.Z`, `X.Y`, `X` and `latest` to both registries |
| `uploadReadme` | branch `main` | README as Docker Hub description, at most 25,000 bytes |
| `github-release` | tag `X.Y.Z`, after `release` | waits for the tag on GitHub, creates the release from the `CHANGELOG.md` entry |

Each platform is built, loaded and tested **before** the push, which reuses those layers from the builder cache — a
broken image never reaches a registry. The test starts every tool of the image; a tool that is added to the Dockerfile
belongs into that test and into the README list. The `docker:dind` service runs with TLS, which buildx only takes from
a Docker context — hence `docker context create dind` before `docker buildx create`. A second platform in
`BUILD_PLATFORMS` needs QEMU (`binfmt_misc`) on the runner host.

CI variables: `DOCKER_HUB_USER`, `DOCKER_HUB_TOKEN`, `GITHUB_TOKEN` (masked, protected — so the tags must be protected
(`*.*.*`) or the jobs see no token). The tokens go in over stdin and through the environment, never onto a command line.

**GitHub mirror:** a push mirror in the GitLab project settings (Repository → Mirroring repositories) with its own
token — not part of the pipeline. `GITHUB_TOKEN` is only for `github-release`, which waits until the mirror has pushed
the tag. Changes are never pushed to GitHub directly; the mirror would overwrite them.

## Release checklist

- `CHANGELOG.md`: `## [X.Y.Z] - <date>` — the tag jobs fail without it, and `github-release` takes the notes from
  exactly that heading.
- The entry names the contained versions under `### Contents`, read from the image right before tagging:
  `docker run --rm epicsoft/ci:latest bash -c 'cat /etc/alpine-release; vault version; kubectl version --client; helm version --short; aws --version; docker --version; docker compose version; git --version'`
- `README.md`: the `## Versions` section, and on a new minor or major version the `X.Y` in the example.
- Tag on `main`, **without `v`**: `X.Y.Z`.

## Local build / test commands

```bash
docker build --pull --no-cache -t ci:local .
docker run --rm ci:local bash -c 'vault version; kubectl version --client; helm version --short'
```

## Conventions

- `.editorconfig`: 2-space indent, LF, UTF-8, final newline, trailing whitespace trimmed (except Markdown), 120 columns
  (180 for YAML, off for Markdown); `.gitattributes` keeps LF in the repository.
- `apk --no-cache upgrade` comes before `apk add`: `apk add` never upgrades the packages of the base image, so their
  security fixes would only arrive with the next base image.
- Commit messages follow Conventional Commits (`feat:`, `fix:`, `ci:`, `chore:`).
