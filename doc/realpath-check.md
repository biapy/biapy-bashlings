# src/realpath.bash

Resolve the real absolute path and check its existance.

## Overview

realpath-check call realpath to resolve a relative path or a symbolic
link to its real absolute path. It then check for its existance and
return an error code if the path does not exists.

## Index

* [realpath-check](#realpath-check)

### realpath-check

Resolve a real absolute path and check its existance.
If the file does not exists, display an error message and return error.
Print its absolute real path on stdout if found.

#### Example

```bash
source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/realpath-check.bash"
file_path="../relative/path"
if file_realpath="$( realpath-check "${file_path}" )"; then
  echo "File found. processing..."
else
  exit 1
fi
```

#### Options

* **-q** | **--quiet**

  Disable the error message.

* **-e** | **--exit**

  Enable exiting on failure.

#### Arguments

* **$1** (string): A path to resolve.

#### Exit codes

* **0**: If successful.
* **1**: If the path does not exists, an argument is missing or more

#### Output on stdout

* The resolved absolute path.

#### Output on stderr

* Error if the argument is missing or more than one argument is given.
* Error if the path does not exist

#### See also

* [realpath](./realpath.md#realpath)
* [process-options](./process-options.md#process-options)
* [cecho](./cecho.md#cecho)

