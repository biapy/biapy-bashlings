#!/usr/bin/env bash
# @file src/internals/validate-option.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Validate an option name and assign its value to its variable.
# @description
#   `validate-option` is a sub-function of `process-options` charged of checking
#   a option name against the allowed options list and assigning the option
#   argument (or 1 in no argument given) to the same-named variable.
# @see process-options

source "${BASH_SOURCE[0]%/*}/../cecho.bash"
source "${BASH_SOURCE[0]%/*}/../in-list.bash"
source "${BASH_SOURCE[0]%/*}/../is-array.bash"

# @description Check if option is allowed, and assign corresponding variable
#   if it is.
#
#   #### Environment
#
#   - **$allowed_options** A list of allowed optins names
#     with * suffix if option argument is allowed and + suffix if option
#     argument is required.
#
# @arg $1 string the option name.
# @arg $2 string (optional) the option argument.
#
# @set processed_options Add $1 to processed_options list if valid option.
# @set option any 1 if --option as no value, "value" if --option=value is used.
# @set ... any variables corresponding to accepted options.
#
# @stderr Error if $1 is not an allowed.
# @stderr Error if the option requires an argument and none is provided.
# @stderr Error if the option does not support arguments and one is provided.
# @stderr Error if argument missing or too many arguments provided.
#
# @exitcode 0 if $1 is a supported long option.
# @exitcode 1 if argument missing or too many arguments provided.
# @exitcode 1 if $1 is not an allowed option.
# @exitcode 1 if the option requires an argument and none is provided.
# @exitcode 1 if the option does not support arguments and one is provided.
function validate-option() {
  # Accept two and only two arguments.
  if [[ ${#} -lt 1 || ${#} -gt 2 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} must have one to two arguments." >&2
    return 1
  fi

  if [[ ! -v 'allowed_options' ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} requires allowed_options variable to be set." >&2
    return 1
  fi

  if ! is-array 'allowed_options'; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} requires allowed_options variable to be an array." >&2
    return 1
  fi

  local option_name="${1}"

  # Default option value is 1, when no argument is provided.
  local option_argument="1"

  local mandatory_value=""
  # Detect the number of dashes based on option name length.
  local dashes='--'
  [[ "${#option_name}" -eq 1 ]] && dashes='-'

  # Build the option validity test regular expression.
  if in-list "${option_name}([*&+]?)" "${allowed_options[@]}"; then
    mandatory_value="${BASH_REMATCH[1]}"

    case "${mandatory_value}" in
    '+' | '&' )
      # Option requires an argument.
      if [[ ${#} -eq 1 ]]; then
        # If no argument is specified, return an error.
        cecho 'ERROR' "Error: ${dashes}${option_name} requires an argument." >&2
        return 1
      fi
      ;;
    '*')
      # Option supports a value, but it is not required.
      : # noop, nothing to do.
      ;;
    *)
      # Option does not support arguments.
      if [[ ${#} -eq 2 ]]; then
        # If an argument is specified, return an error.
        cecho 'ERROR' "Error: ${dashes}${option_name} does not accept arguments." >&2
        return 1
      fi
      ;;
    esac

    # Fetch option argument, if provided.
    if [[ ${#} -eq 2 ]]; then
      option_argument="${2}"
    fi

    # Assign value if --option in allowed_options,
    # Use printf to do $option_name="${option_argument}"
    # Convert all not alphanumeric characters in option_name to _ (eg. - is converted to _)
    printf -v "${option_name//[^[:alnum:]]/_}" "%s" "${option_argument}"

    processed_options+=("${option_name}")
    return 0
  fi

  # Exit with error if a '--option' is not in allowed_options.
  cecho 'ERROR' "Error: option '${dashes}${option_name}' is not recognised." >&2
  return 1
} # validate-option()