# check_binary.bash

Legacy alias for check-binary function.

## Overview

Allow to call `check-binary` by using the legacy name `check_binary`.

## Index

* [check_binary](#check_binary)

### check_binary

Check for the presence of one or more binaries in PATH.
If more than one binary is looked for, output the first found binary
absolute path and exit without error.

#### Example

```bash
source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/check-binary.bash"
check_binary "wget;curl" "wget" >'/dev/null' || exit 1
```

#### See also

* [check_binary](#check_binary)

