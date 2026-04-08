# Ruby Show-off Projects

Minimal Docker-first Ruby projects for file automation, metaprogramming, and web framework internals.

## Features

- CLI Automation Toolkit
- DSL Builder with `task` and `run`
- Lightweight Web Framework with routing, middleware, and request/response handling

## Requirements

- Docker

## Run

```bash
docker compose build
docker compose run --rm app search --path spec/fixtures/smoke --query alpha
docker compose run --rm --entrypoint bundle app exec bin/dsl_builder run --file spec/fixtures/dsl/smoke.rb --task build
docker compose up web_framework
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

## Lightweight Web Framework

Run:

```bash
docker compose up web_framework
```

Test:

```bash
curl -i http://127.0.0.1:9292/
curl -i http://127.0.0.1:9292/missing
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
