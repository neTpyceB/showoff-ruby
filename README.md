# Ruby Show-off Projects

Minimal Docker-first Ruby projects for file automation, metaprogramming, web framework internals, API development, realtime collaboration, Ruby performance work, microservice coordination, and event-driven architecture.

## Features

- CLI Automation Toolkit
- DSL Builder with `task` and `run`
- Lightweight Web Framework with routing, middleware, and request/response handling
- REST API Service with CRUD, validations, JWT auth, and pagination
- Realtime Collaboration System with ActionCable shared state updates and notifications
- High-performance Service with Redis caching, profiling, allocation-aware calculation, and Puma thread tuning
- Microservices Platform with auth, user, worker, API gateway, and service-to-service HTTP calls
- Event-driven Platform with Redis Streams, event reactions, notifications, activity feed, audit log, and retry handling

## Requirements

- Docker

## Run

```bash
docker compose build
docker compose run --rm app search --path spec/fixtures/smoke --query alpha
docker compose run --rm --entrypoint bundle app exec bin/dsl_builder run --file spec/fixtures/dsl/smoke.rb --task build
docker compose up web_framework
docker compose up rest_api
docker compose up realtime_collaboration
docker compose up high_performance
docker compose up microservices_gateway
docker compose up event_driven_platform event_driven_worker
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

## REST API Service

Run:

```bash
docker compose up rest_api
```

Endpoints:

```bash
POST /api/users
POST /api/session
GET /api/posts?page=1&per_page=10
GET /api/posts/:id
POST /api/posts
PATCH /api/posts/:id
DELETE /api/posts/:id
```

Payloads:

```json
{"email":"user@example.com","password":"secret"}
{"title":"Hello","body":"World"}
```

## Realtime Collaboration System

Run:

```bash
docker compose up realtime_collaboration
```

Open:

```bash
http://127.0.0.1:9393/
```

WebSocket:

```bash
ws://127.0.0.1:9393/cable
```

## High-performance Service

Run:

```bash
docker compose up high_performance
```

Open:

```bash
http://127.0.0.1:9494/
```

Work endpoint:

```bash
curl http://127.0.0.1:9494/work?input=35
```

## Microservices Platform

Run:

```bash
docker compose up microservices_gateway
```

Open:

```bash
http://127.0.0.1:9595/
```

Gateway endpoint:

```bash
curl http://127.0.0.1:9595/api/users/1
```

Services:

```text
microservices_gateway -> microservices_auth
microservices_gateway -> microservices_user
microservices_gateway -> microservices_worker
```

## Event-driven Platform

Run:

```bash
docker compose up event_driven_platform event_driven_worker
```

Open:

```bash
http://127.0.0.1:9696/
```

Publish:

```bash
curl -X POST http://127.0.0.1:9696/events -d '{"message":"Issue opened"}'
```

Read models:

```bash
curl http://127.0.0.1:9696/notifications
curl http://127.0.0.1:9696/activity
curl http://127.0.0.1:9696/audit
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
