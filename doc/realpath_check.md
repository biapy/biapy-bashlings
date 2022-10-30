# realpath_check.bash

Legacy alias for realpath-check function.

## Overview

Allow to call `realpath-check` by using the legacy name `realpath_check`.

## Index

* [realpath_check](#realpath_check)

### realpath_check

Resolve a real absolute path and check its existance.
If the file does not exists, display an error message and return error.
Print its absolute real path on stdout if found.

#### Example

```bash
source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/realpath_check.bash"
file_path="../relative/path"
if file_realpath="$( realpath_check "${file_path}" )"; then
  echo "File found. processing..."
else
  exit 1
fi
```

#### Arguments

* -q | --quiet Disable the error message.
* -e | --exit Enable exiting on failure.
* **$1** (string): A path to resolve.

#### Exit codes

* **0**: If successful.
* **1**: If the path does not exists, an argument is missing or more

#### Output on stdout

* The resolved absolute path.

#### See also

* [realpath-check](#realpath-check)

