# Architecture

## Overview

The repository contains two Docker-first Ruby CLIs built from one image.

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

## Runtime Flow

1. Docker starts the Ruby executable
2. The CLI parses one command
3. File I/O loads local inputs
4. The selected operation writes results to stdout

## Scope

- Automation Toolkit: filename search, single-file rename, organize by extension
- DSL Builder: define `task` blocks and execute `run` commands for a named task
- Lightweight Web Framework: serve `GET /`, return `404` for unknown routes, and add response headers through middleware
