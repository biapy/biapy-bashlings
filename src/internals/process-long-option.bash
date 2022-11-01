#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/../cecho.bash"
source "${BASH_SOURCE[0]%/*}/validate-option.bash"

# @description Try to process argument as a long option (starting by --).
#
#   #### Environment
#
#   - **$allowed_options** A list of allowed optins names
#     with * suffix if option argument is allowed and + suffix if option
#     argument is required.
#
# @arg $1 string The argument to be processed.
#
# @set option any 1 if --option as no value, "value" if --option=value is used.
# @set ... any variables corresponding to accepted options.
#
# @stderr Error if the option is not allowed.
#
# @exitcode 0 if the argument is a supported long option.
# @exitcode 1 if $1 is missing.
# @exitcode 2 if $1 is not a long option.
# @exitcode 1 if $1 is not an allowed option.
# @exitcode 1 if the option requires an argument and none is provided.
# @exitcode 1 if the option does not support arguments and one is provided.
#
# @see validate-option()
function process-long-option() {
  # Accept one and only one argument.
  if [[ ${#} -ne 1 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} must have only one argument." >&2
    return 1
  fi

  # Test if argument is a option (starts with '--')
  if [[ "${1}" =~ ^--([^[:space:]=]+)(=?)(.*)$ ]]; then
    # Add option name as first validate-option argument.
    validate_option_arguments=("${BASH_REMATCH[1]}")

    # Store BASH_REMATCH values.
    # Detect if argument is provided.
    if [[ ${BASH_REMATCH[2]} = '=' ]]; then
      # option_argument is value after = character.
      # Add option argument as second validate-option argument, if provided.
      validate_option_arguments+=("${BASH_REMATCH[3]}")
    fi

    validate-option "${validate_option_arguments[@]}"
    return ${?}
  fi

  # Argument is not a long option.
  return 2
} # process-long-option()
