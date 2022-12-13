# src/repeat-string.bash

Repeat a string N times.

## Overview

`repeat-string` output given string repeated N times.

## Index

* [repeat-string](#repeat-string)

### repeat-string

Repeat a string N times.

#### Example

```bash
source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/repeat-string.bash"
repeat-string 40 '-*'
```

#### Arguments

* **$1** (integer): The number of times the given string should be repeated.
* **$2** (string): A string to be repeated.

#### Exit codes

* **0**: If the string is repeated successfully.
* **1**: If an argument is missing or more than two arguments given.
* **2**: If first argument is not a integer.

#### Output on stdout

* The `$2` string repeated `$1` times.

#### Output on stderr

* Error if an argument is missing or more than two arguments given.
* Error if first argument is not a integer.

#### See also

* [cecho](./cecho.md#cecho)
* [How can I repeat a character in Bash?](https://stackoverflow.com/questions/5349718/how-can-i-repeat-a-character-in-bash/23978341#23978341)

