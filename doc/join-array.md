# src/join-array.bash

Join an array contents with a string separator.

## Overview

`join-array` converts an array to string by joining its values with given
string.

## Index

* [join-array](#join-array)

### join-array

Join an array contents by a string. It is similar to PHP `implode`
function.
The separator allows for escaped special characters (e.g. `\n` and `\t`)
by being pre-processed with `printf '%b'`

#### Example

```bash
source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/join-array.bash"
declare -a 'example_array'
example_array=('Dancing' 'on the tune of' 1 'array contents' )
example_string="$(
  join-array ' ~8~ ' ${example_array[@]+"${example_array[@]}"}
)"
```

#### Arguments

* **$1** (string): The separator used to join the array contents.
* **...** (mixed): The contents of the joined array.

#### Exit codes

* **0**: If the array contents is join successfully.
* **1**: If an argument is missing.

#### Output on stdout

* The `$@` array contents joined by `$1` separator.

#### Output on stderr

* Error if an argument is missing.

#### See also

* [cecho](./cecho.md#cecho).
* [PHP implode()](https://www.php.net/manual/function.implode.php).
* [How to join() array elements in a bash script](https://dev.to/meleu/how-to-join-array-elements-in-a-bash-script-303a)

