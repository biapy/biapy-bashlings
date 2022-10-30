# in-list.bash

Test if a value is in a list.

## Overview

in-list test if given string is found in a list.

## Index

* [in-list](#in-list)

### in-list

Test if given string is found in the remaining arguments.

#### Example

```bash
source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/in-list.bash"
value='te(x|s)t'
example_list=( 'test' 'second text' 10 11 )
if in-list "${value}" "${example_list[@]}" then
  echo "Found."
else
  echo "Error: Not found." >&2
  exit 1
fi
```

#### Arguments

* **$1** (string): The searched string, allow for regex syntax (excluding ^ and $).
* **...** (any): The contents of the list in which the string is searched.

#### Exit codes

* **0**: If string is found in list.
* **1**: If string is not found in list, or string is missing.

#### See also

* [cecho](#cecho)

