# Project Rules

## Scope

- Implement only requirements explicitly present in the task description, screens, defined API, or repository docs
- Keep Ruby code minimal, explicit, and free of redundant fallbacks
- Do not add extra validation, entity fields, endpoints, logic branches, defensive programming, design patterns, abstractions, optimizations, placeholders, mocks, or unused code
- Functionality must work completely within the documented scope

## Execution

- Create a plan before implementation
- Follow the plan unless the current requirement forces an update
- Keep `ROADMAP.md` current with completed, current, and next work
- Ask only questions that affect architecture or required logic

## Docker

- Run everything through Docker
- Keep Dockerfiles, Compose, and Makefile commands production-ready and aligned with code
- The system must remain buildable, runnable, and reachable through real requests after changes

## Verification

- Run applicable Docker build, migration, lint, unit, integration, smoke, and end-to-end checks after code changes
- Verify browser/app access, API calls, and persistence where the changed scope includes those surfaces
- Do not proceed past failing checks until fixed

## Documentation

- Keep `README.md`, `ARCHITECTURE.md`, `ROADMAP.md`, `AGENTS.md`, `RULES.md`, `SECURITY_AUDIT.md`, `Makefile`, Docker, and CI files current
- Persist operating instructions in repository docs so future agent runs can continue without chat context
