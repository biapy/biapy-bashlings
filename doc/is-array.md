# src/is-array.bash

Test if a variable is an array.

## Overview

`is-array` test if given variable is an array.

## Index

* [is-array](#is-array)

### is-array

Test if given string is the name of a variable storing an array.

#### Environment

* **$variable** The variable to be tested.

#### Example

```bash
source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/is-array.bash"
example_list=( 'test' 'second text' 10 11 )
is-array 'example_list[@]}' && 'example_list is an array'
```

#### Arguments

* **$1** (string): The name of the variable checked to be an array.

#### Exit codes

* **0**: If variable is a array.
* **1**: If variable is not an array, or is not set.

#### Output on stderr

* Display an error if $1 is missing.

#### See also

* [cecho](./cecho.md#cecho)

