# Hermes Agent — Docker (slim)

Slim Docker image for [Hermes Agent](https://github.com/NousResearch/hermes-agent).

Based on `python:3.13-slim`. Uses `uv` for fast installs, only the necessary extras, and strips `.git` after clone to minimize image size.

Image: `ghcr.io/lisp719/hermes-slim-image:latest`.

Installed extras: `messaging`, `cron`, `cli`, `pty`, `honcho`, `mcp`, `acp`.

## Alias

Add to `~/.bashrc`:

```sh
alias hermes='docker run -it --rm \
  -v ~/.hermes:/opt/data \
  -e HERMES_UID="$(id -u)" \
  -e HERMES_GID="$(id -g)" \
  ghcr.io/lisp719/hermes-slim-image:latest'
```

Then `source ~/.bashrc`.

Variant that mounts the current directory as a workspace:

```sh
alias hermes-cwd='docker run -it --rm \
  -v ~/.hermes:/opt/data \
  -v "$(pwd)":/workspace \
  -w /workspace \
  -e HERMES_UID="$(id -u)" \
  -e HERMES_GID="$(id -g)" \
  ghcr.io/lisp719/hermes-slim-image:latest'
```

`hermes-cwd chat` — same as `hermes chat`, but `$(pwd)` is available at `/workspace` inside the container (e.g. for file operations or ACP project work). Without `-w /workspace` the default WORKDIR is `/opt/hermes` (the agent source tree).

Usage:

| Command              | Action       |
| -------------------- | ------------ |
| `hermes chat`        | Chat session |
| `hermes setup`       | Setup wizard |
| `hermes doctor`      | Health check |
| `hermes gateway run` | API server   |

Add `-p 8642:8642` inside the alias if you use the gateway often.

## Commands (with compose)

```sh
# Build
docker compose build

# Run gateway (port 8642)
docker compose up -d

# Interactive chat
docker compose run --rm app chat

# Setup / doctor
docker compose run --rm app setup
docker compose run --rm app doctor
```

With [Task](https://taskfile.dev/): `task`, `task setup`, `task doctor`.

Config goes in `~/.hermes/config.yaml` (mounted to `/opt/data`). Set `HERMES_UID`/`HERMES_GID` if your host UID differs from 1000.
