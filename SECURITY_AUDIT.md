# Security Audit

## Current State

- No shell command execution from user input
- File operations use Ruby file APIs directly
- Docker runtime uses a non-root user
- Command scope is limited to local filesystem operations provided by CLI arguments
- DSL execution runs the shell commands declared in the DSL file supplied by the operator
- The web framework exposes only the local HTTP server declared in Docker Compose
- The REST API exposes JSON endpoints on port 3000 and uses JWT bearer tokens
- The realtime service exposes one browser page and one ActionCable WebSocket endpoint on port 9393
- The high-performance service exposes one browser page and one profiled work endpoint on port 9494

## Accepted Scope

- The tool acts on the paths given by the operator
- The DSL Builder executes task commands exactly as written in the loaded DSL file
- The web framework handles only local HTTP requests and returns plain text responses
- Only the local web framework service is exposed through Docker Compose on port 9292
- The API stores user credentials as bcrypt password digests in PostgreSQL
- The API protects post CRUD routes with JWT bearer authentication
- The realtime service keeps only in-memory shared document state
- The realtime service allows local browser origins for ActionCable connections
- The high-performance service caches calculated numeric results in Redis
- No background processes are started
