# Ruby CLI Show-off Projects

Minimal Docker-first Ruby CLI projects for file automation and DSL execution.

## Features

- CLI Automation Toolkit
- DSL Builder with `task` and `run`

## Requirements

- Docker

## Run

```bash
docker compose build
docker compose run --rm app search --path spec/fixtures/smoke --query alpha
docker compose run --rm --entrypoint bundle app exec bin/dsl_builder run --file spec/fixtures/dsl/smoke.rb --task build
```

## CLI Automation Toolkit

```bash
docker compose run --rm app search --path PATH --query QUERY
docker compose run --rm app rename --path PATH --name NEW_NAME
docker compose run --rm app organize --path PATH
```

Optional for every command:

```bash
--log-level debug
```

## DSL Builder

DSL file:

```ruby
task 'build' do
  run 'npm install'
end
```

Run:

```bash
docker compose run --rm --entrypoint bundle app exec bin/dsl_builder run --file PATH_TO_DSL --task build
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
