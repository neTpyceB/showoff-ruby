# Security Audit

## Current State

- No shell command execution from user input
- File operations use Ruby file APIs directly
- Docker runtime uses a non-root user
- Command scope is limited to local filesystem operations provided by CLI arguments
- DSL execution runs the shell commands declared in the DSL file supplied by the operator
- The web framework exposes only the local HTTP server declared in Docker Compose

## Accepted Scope

- The tool acts on the paths given by the operator
- The DSL Builder executes task commands exactly as written in the loaded DSL file
- The web framework handles only local HTTP requests and returns plain text responses
- Only the local web framework service is exposed through Docker Compose on port 9292
- No background processes are started
