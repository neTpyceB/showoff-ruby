# Architecture

## Overview

The project is a single-process Ruby CLI packaged for Docker execution.

## Components

- `bin/toolkit`: executable entrypoint
- `AutomationToolkit::ArgumentParser`: turns CLI arguments into immutable configuration
- `AutomationToolkit::Runner`: dispatches the selected command
- `AutomationToolkit::DirectoryEntries`: yields direct child files with a block-backed enumerator
- `AutomationToolkit::Commands`: search, rename, and organize operations

## Runtime Flow

1. Parse CLI arguments into `AutomationToolkit::Configuration`
2. Build a logger bound to stderr
3. Execute a single command
4. Print command results to stdout

## File Operation Scope

- `search`: matches direct child filenames containing the query
- `rename`: renames one file to the provided sibling filename
- `organize`: moves direct child files with extensions into sibling extension folders
