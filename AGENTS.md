# Agent Notes

## Project
- Name: Ruby CLI Show-off Projects
- Scope: Automation Toolkit plus DSL Builder
- Runtime: Docker-first Ruby CLIs

## Commands
- Build: `docker compose build`
- Lint: `docker compose run --rm --entrypoint bundle app exec rubocop`
- Test: `docker compose run --rm --entrypoint bundle app exec rspec`
- Smoke: `docker compose run --rm app search --path spec/fixtures/smoke --query alpha`
- Smoke DSL: `docker compose run --rm --entrypoint bundle app exec bin/dsl_builder run --file spec/fixtures/dsl/smoke.rb --task build`

## Constraints
- Keep implementation minimal and explicit to the documented scope
- Do not add features beyond the current command sets
- Keep docs, roadmap, CI, and Docker configuration aligned with code
