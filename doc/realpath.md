# src/realpath.bash

Resolve the real absolute path.

## Overview

`realpath` resolves a relative path or a symbolic link to its real
absolute path.

## Index

* [realpath](#realpath)

### realpath

Resolve the real absolute path.

#### Example

```bash
source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/realpath.bash"
file_path="../relative/path"
file_realpath="$( realpath "${file_path}" || echo "${file_path}" )"
```

#### Arguments

* **$1** (string): A path to resolve.

#### Exit codes

* **0**: If successful.
* **1**: If argument is missing or more than one argument given.
* **1**: If realpath not found.

#### Output on stdout

* The resolved absolute path, or empty string if realpath not found.

#### Output on stderr

* Error if argument is missing or more than one argument given.

#### See also

* [How can I get the behavior of GNU's readlink -f on a Mac?](https://stackoverflow.com/questions/1055671/how-can-i-get-the-behavior-of-gnus-readlink-f-on-a-mac)
* [bats-core bats command](https://github.com/bats-core/bats-core/blob/master/bin/bats)
* [cecho](./cecho.md#cecho)

