# src/internals/process-short-options.bash

Process an argument as a short option (starting with -).

## Overview

`process-short-options` is a sub-function of `process-options` charged of
processing arguments starting with a single dash.

## Index

* [process-short-options](#process-short-options)

### process-short-options

Try to process argument as short options (starting by -).
Short options can be any letter among a-z and A-Z.

#### Environment

* **$allowed_options** A list of allowed options names
  with * suffix if option argument is allowed and + suffix if option
  argument is required.

#### Arguments

* **$1** (string): The argument to be processed.

#### Variables set

* **o** (int): 1 if o found in short options string.
* **...** (any): one letter variables corresponding to accepted short options.

#### Exit codes

* **0**: if the argument is a supported long option.
* **1**: if $1 is missing.
* **2**: if $1 is not a sort option.
* **1**: if $1 is not an allowed option.
* **1**: if the option requires an argument and none is provided.
* **1**: if the option does not support arguments and one is provided.

#### Output on stderr

* Error if the option is not allowed.

#### See also

* [validate-option](./validate-option.md#validate-option)
* [process-options](../process-options.md#process-options)

