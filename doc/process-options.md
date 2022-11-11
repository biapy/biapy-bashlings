# src/process-options.bash

Alternative getopt for functions.

## Overview

process-options is alternative getopt for functions that automatically
assign an option argument (or 1 if no arguement given) to the same-named
variable.

## Index

* [process-options](#process-options)

### process-options

Alternative getopt for functions.

#### Warning

This function should only be used for functions, i.e. when you
control input. For the main "public" script, prefer loop manualy over the
provided arguments to process options.

For more information on Bash command-line options handling see:

- [How can I handle command-line options and arguments in my script easily? @ BashFAQ](https://mywiki.wooledge.org/BashFAQ/035).
- [Complex Option Parsing @ BashFAQ](https://mywiki.wooledge.org/ComplexOptionParsing).

#### Usage

$1 is a space separated string of allowed options with this syntax:
- [a-zA-Z] : letter option allowed for single dash short option.
- option : Option trigger, without argument (--option).
- option* : Option with optional argument (--option=value).
- option& : Option with mandatory argument (--option=value)
- option+ : Mandatory option with mandatory argument (--option=value)

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
  local allowed_options=( 'q' 'quiet' 'v' 'verbose' 'user-agent'
    'optional-argument*' 'mandatory-argument&'
    'mandatory-option-with-mandatory-argument+' )
  # Declare option variables as local.
  # arguments is a default of process-options function.
  # It is similar to "${@}" without values starting by '--'.
  local arguments=()
  local q=0
  local quiet=0
  local v=0
  local verbose=0
  local user_agent=''
  local mandatory=''
  local mandatory_with_value=''
  # Call the process-options function:
  process-options "${allowed_options[*]}" "${@}" || return 1
  # Process short options.
  quiet=$(( quiet + q ))
  verbose=$(( verbose+ v ))
  # Display arguments that are not an option:
  printf '%s\n' "${arguments[@]}"
}
# Call example_function with:
example_function -q --quiet -v 0 --verbose=0 --user-agent="Mozilla" --mandatory \
  --mandatory_with_value="mandatory value" -- arg1 arg2 --arg3 arg4
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

#### Output on stderr

* Error if unsupported option (invalid argument) is encoutered.
* Error if mandatory option value is missing.

#### See also

* [cecho](./cecho.md#cecho)
* [in-list](./in-list.md#in-list)

