# realpath.bash

Resolve the real absolute path.

## Overview

realpath resolve a relative path or a symbolic link to its real absolute
path.

## Index

* [realpath](#realpath)

### realpath

Resolve the real absolute path.

#### Example

```bash
source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/realpath.bash"
file_path="../relative/path"
file_realpath="$( realpath "${file_path}" )"
```

#### Arguments

* **$1** (string): A path to resolve.

#### Exit codes

* **0**: If successful.
* **1**: If argument is missing or more than one argument given.

#### Output on stdout

* The resolved absolute path.

