# Security Audit

## Current State

- No shell command execution from user input
- File operations use Ruby file APIs directly
- Docker runtime uses a non-root user
- Command scope is limited to local filesystem operations provided by CLI arguments

## Accepted Scope

- The tool acts on the paths given by the operator
- No network services are exposed
- No background processes are started
