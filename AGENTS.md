# Agent Notes

## Project
- Name: Ruby Show-off Projects
- Scope: Automation Toolkit, DSL Builder, and Lightweight Web Framework
- Runtime: Docker-first Ruby CLIs and one local HTTP service

## Commands
- Build: `docker compose build`
- Lint: `docker compose run --rm --entrypoint bundle app exec rubocop`
- Test: `docker compose run --rm --entrypoint bundle app exec rspec`
- Smoke: `docker compose run --rm app search --path spec/fixtures/smoke --query alpha`
- Smoke DSL: `docker compose run --rm --entrypoint bundle app exec bin/dsl_builder run --file spec/fixtures/dsl/smoke.rb --task build`
- Smoke Web: `docker compose up -d web_framework && curl http://127.0.0.1:9292/`

## Constraints
- Keep implementation minimal and explicit to the documented scope
- Do not add features beyond the current command sets
- Keep docs, roadmap, CI, and Docker configuration aligned with code
