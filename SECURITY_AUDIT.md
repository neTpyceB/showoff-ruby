# Security Audit

## Current State

- No shell command execution from user input
- File operations use Ruby file APIs directly
- Docker runtime uses a non-root user
- Command scope is limited to local filesystem operations provided by CLI arguments
- DSL execution runs the shell commands declared in the DSL file supplied by the operator

## Accepted Scope

- The tool acts on the paths given by the operator
- The DSL Builder executes task commands exactly as written in the loaded DSL file
- No network services are exposed
- No background processes are started
