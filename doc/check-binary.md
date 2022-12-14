# src/check-binary.bash

Check for the presence of a binary in $PATH.

## Overview

`check-binary` checks if a binary is available in PATH. If the
binary is not avaible, it invites to install the corresponding package.

## Index

* [check-binary](#check-binary)

### check-binary

Check for the presence of one or more binaries in PATH.
If more than one binary is looked for, output the first found binary
absolute path and exit without error.
If no looked-for binary is avaible, display an invite to install the
corresponding package and exit with error.

#### Example

```bash
source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/check-binary.bash"
check-binary "wget;curl" "wget" >'/dev/null' || exit 1
```

#### Arguments

* **$1** (string): A semicolon separated list of binary names.
* **$2** (string): The binary's package name.

#### Exit codes

* **0**: If binary is found in PATH.
* **1**: If less or more than 2 arguments provided.
* **1**: If binary is not found in PATH.

#### Output on stdout

* The first found binary absolute path, as outputted by `command -v`.

#### Output on stderr

* Error if number of arguments is not 2.
* Error if no binary found, recommending the installation of `$2` package.

#### See also

* [cecho](./cecho.md#cecho)

