# Agent Notes

## Project
- Name: CLI Automation Toolkit
- Scope: filename search, single-file rename, organize direct child files by extension
- Runtime: Docker-first Ruby CLI

## Commands
- Build: `docker compose build`
- Lint: `docker compose run --rm --entrypoint bundle app exec rubocop`
- Test: `docker compose run --rm --entrypoint bundle app exec rspec`
- Smoke: `docker compose run --rm app search --path spec/fixtures/smoke --query alpha`

## Constraints
- Keep implementation minimal and explicit to the documented scope
- Do not add features beyond the current command set
- Keep docs, roadmap, CI, and Docker configuration aligned with code
