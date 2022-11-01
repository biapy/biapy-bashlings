# process-options.bash

Alternative getopt for functions.

## Overview

process-options is alternative getopt for functions that automatically
assign an option argument (or 1 if no arguement given) to the same-named
variable.

## Index

* [process-options](#process-options)

### process-options

Alternative getopt for functions.
Store values in theses global variables:
- arguments[] : arguments that does not start by - or are after a '--'.
- "${option_name}" : variable named after each argument starting by '--' (e.g. --option_name) or '-' (e.g. -o).

store allowed --myOption="value" in variable $myOption.
store allowed --my-option="value" in variable $my_option.
if --myOption or has no value set, set it to 1.

#### Example

```bash
example_function () {
  # Describe function options.
  local allowed_options=( 'q' 'quiet' 'v' 'verbose' 'user_agent'
    'mandatory*' 'mandatory_with_value+' )
```

#### Arguments

* **$1** (string): Space separated listed of allowed options.
* **...** (any): aguments to process.

#### Variables set

* **option** (any): 1 if --option as no value, "value" if --option=value is used.
* **...** (any): variables corresponding to accepted options.

#### Exit codes

* **0**: If options where processed without error.
* **1**: If a unsupported option is encountered.
* **1**: If a mandatory option is missing its value..

#### See also

* [cecho](#cecho)
* [in-list](#in-list)

