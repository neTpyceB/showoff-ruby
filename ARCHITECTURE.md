# Architecture

## Overview

The repository contains multiple Docker-first Ruby executables, one database-backed JSON API service, one ActionCable realtime service, and one Redis-backed performance service.

## CLI Automation Toolkit

- `bin/toolkit`: executable entrypoint
- `AutomationToolkit::ArgumentParser`: turns CLI arguments into immutable configuration
- `AutomationToolkit::Runner`: dispatches the selected command
- `AutomationToolkit::DirectoryEntries`: yields direct child files with a block-backed enumerator
- `AutomationToolkit::Commands`: search, rename, and organize operations

## DSL Builder

- `bin/dsl_builder`: executable entrypoint
- `DslBuilder::CLI`: parses `run --file --task`
- `DslBuilder::Loader`: reads the DSL file and evaluates top-level declarations with `instance_eval`
- `DslBuilder::TaskRegistry`: stores named task blocks
- `DslBuilder::Executor`: evaluates the selected task block and executes `run` commands

## Lightweight Web Framework

- `bin/lightweight_web_framework`: boots the demo application
- `LightweightWebFramework::Router`: resolves routes by verb and path
- `LightweightWebFramework::Application`: composes middleware around the router
- `LightweightWebFramework::Request` and `LightweightWebFramework::Response`: explicit HTTP objects
- `LightweightWebFramework::Server`: adapts WEBrick requests to framework objects
- `LightweightWebFramework::DemoApp`: minimal app that proves routing, middleware, and responses

## REST API Service

- `bin/rest_api_service`: boots the Sinatra API with Puma
- `bin/rest_api_migrate`: runs Sequel migrations
- `RestApiService::App`: defines the JSON endpoints
- `RestApiService::Models::User`: validates login data and stores password digests
- `RestApiService::Models::Post`: validates CRUD resource data
- `RestApiService::Authenticator`: issues and verifies JWT tokens
- `RestApiService::Paginator`: slices list responses
- PostgreSQL: stores users and posts

## Realtime Collaboration System

- `bin/realtime_collaboration`: boots the Rack/ActionCable service with Puma
- `RealtimeCollaboration::App`: serves the browser client
- `RealtimeCollaboration::CollaborationChannel`: streams shared state and notification events
- `RealtimeCollaboration::State`: keeps the single in-memory shared document state
- ActionCable async adapter: broadcasts WebSocket messages inside the running process

## High-performance Service

- `bin/high_performance_service`: boots the Rack service with Puma thread settings
- `HighPerformanceService::App`: serves the browser page and `/work?input=`
- `HighPerformanceService::Calculator`: computes Fibonacci values iteratively
- `HighPerformanceService::Cache`: stores computed values in Redis
- `HighPerformanceService::Profiler`: returns CPU time, object allocation, and memory deltas
- Redis: stores cached calculation results

## Runtime Flow

1. Docker starts the Ruby executable
2. The CLI parses one command
3. File I/O loads local inputs
4. The selected operation writes results to stdout

## Realtime Flow

1. Browser opens `GET /`
2. Browser connects to `/cable`
3. Client subscribes to `RealtimeCollaboration::CollaborationChannel`
4. Channel transmits the current state
5. Client sends an `update` action
6. Channel broadcasts the shared state and notification messages

## Performance Flow

1. Browser opens `GET /`
2. Client requests `/work?input=35`
3. Service checks Redis for the computed result
4. Service computes missing values with the iterative calculator
5. Service returns the result, cache state, and profile metrics

## Scope

- Automation Toolkit: filename search, single-file rename, organize by extension
- DSL Builder: define `task` blocks and execute `run` commands for a named task
- Lightweight Web Framework: serve `GET /`, return `404` for unknown routes, and add response headers through middleware
- REST API Service: user signup, JWT login, protected post CRUD, and page-based listing
- Realtime Collaboration System: one shared document state, ActionCable update broadcasts, and notification broadcasts
- High-performance Service: one profiled Fibonacci work endpoint backed by Redis caching and Puma thread tuning
