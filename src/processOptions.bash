#!/usr/bin/env bash

# Alternative getopt for functions.
#
# Store values in theses global variables:
#  - arguments[] : arguments that does not start by -- or are after a '--'.
#  - "${optionName}" : variable named after each argument starting by '--' (--optionName).
#
# Example usage:
# example_function () {
#   # Describe function options.
#   local allowedOptions=( 'quiet' 'verbose' 'user_agent' 'mandatory*' 'mandatoryWithValue+' )
#
#   # Declare option variables as local.
#   # arguments is a default of processOptions function. It is similar to "${@}" without values starting by '--'.
#   local arguments=()
#   local quiet=0
#   local verbose=0
#   local user_agent=''
#   local mandatory=''
#   local mandatoryWithValue=''
#
#   # Call the processOptions function:
#   processOptions "${allowedOptions[*]}" "${@}" || return 1
#
#   # Display arguments that are not an option:
#   printf '%s\n' "${arguments[@]}"
# }
#
# # Call example_function with:
# example_function --quiet --verbose=0 --user-agent="Mozilla" --mandatory --mandatoryWithValue="mandatory value" -- arg1 arg2 --arg3 arg4

source 'cecho.bash'

# store allowed --myOption="value" in variable myOption.
# if --myOption has no value set, set it to 1.
#
# @param string allowedOptionsList Space separated listed of allowed options.
#         an option name ending by '*' mark the option as mandatory.
#         an option name ending by '+' mark the option as mandatory with a non empty value.
# @param ${@} aguments to process.
# @return 1 on error, 0 on success.
function processOptions() {
  ### arguments handling.
  local allowedOptionsString="${1}"
  local allowedOptions=()
  local processedOptions=()
  local optionName=''
  local optionValue=''
  local optionDefault=''
  local optionValidityTest=''
  local cleanedOptionName=''
  local optionPresenceTest=''

  # Discard first argument (allowedOptionsString)
  shift

  # Split allowed options string on space.
  IFS=' ' read -r -a 'allowedOptions' <<< "${allowedOptionsString}"

  arguments=()

  # Loop over arguments.
  while [[ "${#}" -gt 0 && "${1}" != '--' ]]; do # For each function argument until a '--'.
    # Test if argument is a option (starts with '--')
    if [[ "${1}" =~ ^--([^=]*)(=?)(.*)$ ]]; then
      optionName="${BASH_REMATCH[1]//[^[:alnum:]]/_}"

      # Store BASH_REMATCH values. option default is '' if = present, 1 otherwise.
      optionDefault="${BASH_REMATCH[2]:-1}"
      optionValue="${BASH_REMATCH[3]:-${optionDefault//=/}}"

      # Build the option validity test regular expression.
      optionValidityTest="^.*[ ]${optionName}[*+]?[ ].*\$"
      if [[ " ${allowedOptions[*]} " =~ ${optionValidityTest} ]]; then
        # Assign value if --option in allowedOptions,
        # Use printf to do $optionName="${optionValue}"
        printf -v "${optionName}" "%s" "${optionValue}"
        processedOptions+=("${optionName}")
      else
        # Exit with error if a '--option' is not in allowedOptions.
        cecho 'red' "Error: invalid argument ${1}." >&2
        return 1
      fi

    else
      # Argument is not an option, store it for future use.
      arguments+=("${1}")
    fi

    shift
  done

  # Handle arguments after '--'
  [[ "${1}" = '--' ]] && shift && arguments+=("${@}")

  # For each mandatory argument, test its presence.
  for optionName in "${allowedOptions[@]}"; do
    # Build the option presence test regular expression.
    cleanedOptionName="${optionName%[+*]}"

    # Test if option is mandatory
    # (cleanedOptionName is different of optionName)
    # (optionName end by + or *)
    if [[ "${cleanedOptionName}" != "${optionName}" ]]; then
      optionPresenceTest="^.*[ ]${cleanedOptionName}[ ].*\$"

      # Test if mandatory option is present.
      if [[ ! " ${processedOptions[*]} " =~ ${optionPresenceTest} ]]; then
        cecho 'red' "Error: --${cleanedOptionName} is missing." >&2
        return 1
      fi

      # Test if option need a mandatory value (end by +) and option is empty.
      if [[ "${optionName}" = "${cleanedOptionName}+" &&
        -z "${!cleanedOptionName}" ]]; then
        cecho 'red' "Error: --${cleanedOptionName} is empty." >&2
        return 1
      fi
    fi
  done

  return 0
} # processOptions()
