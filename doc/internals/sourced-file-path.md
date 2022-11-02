# src/internals/sourced-file-path.bash

Compute sourced file path from a bash source (or dot) command.

## Overview

`sourced-file-path` is a sub-function of `assemble-sources` that compute
a source command sourced file path.

## Index

* [function sourced-file-path {](#function-sourced-file-path-)

### function sourced-file-path {

Get sourced file from source (or dot) command.

#### Example

```bash
source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/internals/sourced-file-path.bash"
sourced_file="$(
    sourced-file-path 'source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/cecho.bash"'
  )"
```

#### Arguments

* --debug bool Enable debug output.
* --origin string The file in which the source command is found.
* **$1** (string): A Bash source or . (dot) include command.

#### Exit codes

* **0**: on success.
* **1**: if invalid option is given.
* **1**: if argument is missing or too many arguments given.
* **1**: if source command can't be parsed.
* **1**: if sourced file does not exists.

#### Output on stdout

* Sourced file relative path to source command file.

