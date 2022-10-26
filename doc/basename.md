# basename.bash

Strip directory from filenames.

## Overview

basename print filename with any leading directory components removed.

## Index

* [basename](#basename)

### basename

Strip directory from filenames.

#### Example

```bash
source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/basename.bash"
file_path="../path/to/some/file"
file_basename="$( basename "${file_path}" )"
```

#### Arguments

* **$1** (string): A filename to strip.

#### Exit codes

* **0**: If successful.
* **1**: If argument is missing or more than one argument given.

#### Output on stdout

* The filename without any leading directory components.

