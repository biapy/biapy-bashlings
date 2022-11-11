# src/internals/validate-option.bash

Validate an option name and assign its value to its variable.

## Overview

`validate-option` is a sub-function of `process-options` charged of checking
a option name against the allowed options list and assigning the option
argument (or 1 in no argument given) to the same-named variable.

## Index

* [validate-option](#validate-option)

### validate-option

Check if option is allowed, and assign corresponding variable
if it is.

#### Environment

- **$allowed_options** A list of allowed optins names
with * suffix if option argument is allowed and + suffix if option
argument is required.

#### Arguments

* **$1** (string): the option name.
* **$2** (string): (optional) the option argument.

#### Variables set

* **processed_options** (Add): $1 to processed_options list if valid option.
* **option** (any): 1 if --option as no value, "value" if --option=value is used.
* **...** (any): variables corresponding to accepted options.

#### Exit codes

* **0**: if $1 is a supported long option.
* **1**: if argument missing or too many arguments provided.
* **1**: if $1 is not an allowed option.
* **1**: if the option requires an argument and none is provided.
* **1**: if the option does not support arguments and one is provided.

#### Output on stderr

* Error if $1 is not an allowed.
* Error if the option requires an argument and none is provided.
* Error if the option does not support arguments and one is provided.
* Error if argument missing or too many arguments provided.

#### See also

* [process-options](../process-options.md#process-options)

