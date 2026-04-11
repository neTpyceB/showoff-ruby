# Agent Notes

## Project
- Name: Ruby Show-off Projects
- Scope: Automation Toolkit, DSL Builder, Lightweight Web Framework, REST API Service, Realtime Collaboration System, and High-performance Service
- Runtime: Docker-first Ruby CLIs, one local HTTP service, one database-backed API, one ActionCable WebSocket service, and one Redis-backed performance service

## Commands
- Build: `docker compose build`
- Lint: `docker compose run --rm --entrypoint bundle app exec rubocop`
- Test: `docker compose up --wait -d cache db && docker compose run --rm -e DATABASE_URL=postgres://postgres:postgres@host.docker.internal:5432/showoff_ruby_development -e JWT_SECRET=test-secret --entrypoint bundle app exec ruby bin/rest_api_migrate && docker compose run --rm -e DATABASE_URL=postgres://postgres:postgres@host.docker.internal:5432/showoff_ruby_development -e JWT_SECRET=test-secret --entrypoint bundle app exec rspec`
- Smoke: `docker compose run --rm app search --path spec/fixtures/smoke --query alpha`
- Smoke DSL: `docker compose run --rm --entrypoint bundle app exec bin/dsl_builder run --file spec/fixtures/dsl/smoke.rb --task build`
- Smoke Web: `docker compose up -d web_framework && curl http://127.0.0.1:9292/`
- Migrate API: `docker compose run --rm -e DATABASE_URL=postgres://postgres:postgres@host.docker.internal:5432/showoff_ruby_development -e JWT_SECRET=test-secret --entrypoint bundle app exec ruby bin/rest_api_migrate`
- Smoke API: `docker compose up -d rest_api && curl http://127.0.0.1:3000/api/posts`
- Smoke Realtime: `docker compose up -d realtime_collaboration && curl http://127.0.0.1:9393/`
- Smoke Performance: `docker compose up -d high_performance && curl http://127.0.0.1:9494/work?input=35`

## Constraints
- Keep implementation minimal and explicit to the documented scope
- Do not add features beyond the current command sets
- Keep docs, roadmap, CI, and Docker configuration aligned with code
- Create a plan before implementation and follow it unless the task requires a change
- Implement only requirements explicitly present in the task, screens, API, or docs
- Do not add extra validation, fields, endpoints, branches, fallback logic, defensive duplication, unused abstractions, or optimizations
- Use Docker for build, runtime, migration, lint, tests, smoke checks, and manual verification
- After code changes, run the applicable Docker build, migration, lint, test, smoke, and real-request checks before proceeding
- Keep README, ARCHITECTURE, ROADMAP, RULES, SECURITY_AUDIT, AGENTS, Makefile, Docker, and CI files current with the real project state
- Report only results, working behavior, changed files, verification, and follow-up actions
