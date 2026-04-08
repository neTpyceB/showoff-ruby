# CLI Automation Toolkit

Minimal Docker-first Ruby CLI for file search, rename, and organization.

## Features

- Search direct child filenames by query
- Rename a file
- Organize direct child files into extension folders
- Configure commands with CLI arguments
- Emit structured log output

## Requirements

- Docker

## Run

```bash
docker compose build
docker compose run --rm app search --path spec/fixtures/smoke --query alpha
```

## Commands

```bash
docker compose run --rm app search --path PATH --query QUERY
docker compose run --rm app rename --path PATH --name NEW_NAME
docker compose run --rm app organize --path PATH
```

Optional for every command:

```bash
--log-level debug
```

## Quality Gates

- Lint: `make lint`
- Test: `make test`
- Smoke: `make smoke`

## Project Docs

- `ARCHITECTURE.md`
- `ROADMAP.md`
- `RULES.md`
- `SECURITY_AUDIT.md`
- `AGENTS.md`
