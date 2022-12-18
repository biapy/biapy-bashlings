# src/available-fd.bash

Find first unused file descriptor (fd) (for `bash` < 4.1 (e.g. macOS)).

## Overview

`available-fd` looks for an unused file descriptor and output its number
on stdout.

## Index

* [available-fd](#available-fd)

### available-fd

`available-fd` looks for an unused file descriptor (fd) in the range 10 to
200 and output its number on stdout.
This function is useful for `bash` < 4.1 (e.g. macOS).

#### Example

```bash
source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/available-fd.bash"
if error_fd="$(available-fd '2')"; then
  fd_target='&2'
  ((quiet)) && fd_target='/dev/null'
  eval "exec ${error_fd}>${fd_target}"
fi
```

#### Arguments

* **$1** (integer): A default fd is no available fd is found.

#### Exit codes

* **0**: If an available fd is found.
* **1**: If no fd between 10 and 200 is available.
* **2**: If more than one argument present.
* **3**: If `$1` is not an integer.

#### Output on stdout

* The available file descriptor number, or `$1` if none found.

#### Output on stderr

* Error if more than one argument present.
* Error if argument is not an integer.

#### See also

* [cecho](./cecho.md#cecho).
* [How to find next available file descriptor in Bash?](https://stackoverflow.com/questions/41603787/how-to-find-next-available-file-descriptor-in-bash/41626332#41626332)

