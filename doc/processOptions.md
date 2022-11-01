# processOptions.bash

Legacy alias for process-options function.

## Overview

Allow to call `process-options` by using the legacy name `processOptions`.

## Index

* [processOptions](#processoptions)

### processOptions

Alternative getopt for functions.
Store values in theses global variables:
- arguments[] : arguments that does not start by - or are after a '--'.
- "${option_name}" : variable named after each argument starting by '--' (e.g. --option_name) or '-' (e.g. -o).

store allowed --myOption="value" in variable $myOption.
store allowed --my-option="value" in variable $my_option.
if --myOption or has no value set, set it to 1.

@deprecated

#### See also

* [process-options](#process-options)

