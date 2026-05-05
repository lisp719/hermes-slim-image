# Hermes Agent — Docker (slim)

Slim Docker image for [Hermes Agent](https://github.com/NousResearch/hermes-agent).

Based on `python:3.13-slim`. Uses `uv` for fast installs, only the necessary extras, and strips `.git` after clone to minimize image size.

Installed extras: `messaging`, `cron`, `cli`, `pty`, `honcho`, `mcp`, `acp`.

## Commands

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
