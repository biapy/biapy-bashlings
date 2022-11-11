#!/usr/bin/env bash
# @file src/process-options.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Alternative getopt for functions.
# @description
#   process-options is alternative getopt for functions that automatically
#   assign an option argument (or 1 if no arguement given) to the same-named
#   variable.

source "${BASH_SOURCE[0]%/*}/cecho.bash"
source "${BASH_SOURCE[0]%/*}/in-list.bash"
source "${BASH_SOURCE[0]%/*}/internals/process-long-option.bash"
source "${BASH_SOURCE[0]%/*}/internals/process-short-options.bash"

# @description Alternative getopt for functions.
#
#  #### Warning
#
#  This function should only be used for functions, i.e. when you
#  control input. For the main "public" script, prefer loop manualy over the
#  provided arguments to process options.
#  
#  For more information on Bash command-line options handling see:
#
#  - [How can I handle command-line options and arguments in my script easily? @ BashFAQ](https://mywiki.wooledge.org/BashFAQ/035).
#  - [Complex Option Parsing @ BashFAQ](https://mywiki.wooledge.org/ComplexOptionParsing).
#
#  #### Usage
#
#  $1 is a space separated string of allowed options with this syntax:
#  - [a-zA-Z] : letter option allowed for single dash short option.
#  - option : Option trigger, without argument (--option).
#  - option* : Option with optional argument (--option=value).
#  - option& : Option with mandatory argument (--option=value)
#  - option+ : Mandatory option with mandatory argument (--option=value)
#
#  Store values in theses global variables:
#  - arguments[] : arguments that does not start by - or are after a '--'.
#  - "${option_name}" : variable named after each argument starting by '--' (e.g. --option_name) or '-' (e.g. -o).
#
#  store allowed --myOption="value" in variable $myOption.
#  store allowed --my-option="value" in variable $my_option.
#  if --myOption or has no value set, set it to 1.
#
# @example
#     example_function () {
#       # Describe function options.
#       local allowed_options=( 'q' 'quiet' 'v' 'verbose' 'user-agent'
#         'optional-argument*' 'mandatory-argument&'
#         'mandatory-option-with-mandatory-argument+' )
#       # Declare option variables as local.
#       # arguments is a default of process-options function.
#       # It is similar to "${@}" without values starting by '--'.
#       local arguments=()
#       local q=0
#       local quiet=0
#       local v=0
#       local verbose=0
#       local user_agent=''
#       local mandatory=''
#       local mandatory_with_value=''
#       # Call the process-options function:
#       process-options "${allowed_options[*]}" "${@}" || return 1
#       # Process short options.
#       quiet=$(( quiet + q ))
#       verbose=$(( verbose+ v ))
#       # Display arguments that are not an option:
#       printf '%s\n' "${arguments[@]}"
#     }
#     # Call example_function with:
#     example_function -q --quiet -v 0 --verbose=0 --user-agent="Mozilla" --mandatory \
#       --mandatory_with_value="mandatory value" -- arg1 arg2 --arg3 arg4
#
# @arg $1 string Space separated listed of allowed options.
#         - an option name ending by '*' mark the option as accepting a value.
#         - an option name ending by '+' mark the option as requiring a value.
# @arg $@ any aguments to process.
#
# @set option any 1 if --option as no value, "value" if --option=value is used.
# @set ... any variables corresponding to accepted options.
#
# @exitcode 0 If options where processed without error.
# @exitcode 1 If a unsupported option is encountered.
# @exitcode 1 If a mandatory option is missing its value..
#
# @stderr Error if unsupported option (invalid argument) is encoutered.
# @stderr Error if mandatory option value is missing.
#
# @see [cecho](./cecho.md#cecho)
# @see [in-list](./in-list.md#in-list)
function process-options() {
  # Must have at least one argument (the allowed option list).
  if [[ ${#} -eq 0 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} requires at least one argument." >&2
    return 1
  fi

  ### arguments handling.
  local allowed_options_list="${1}"
  local allowed_options=()
  local processed_options=()
  local return_code
  local option_name=''
  local cleaned_option_name=''

  # Discard first argument (allowed_options_list)
  shift

  # Split allowed options string on space.
  IFS=' ' read -r -a 'allowed_options' <<<"${allowed_options_list}"

  arguments=()

  # Loop over arguments.
  while [[ "${#}" -gt 0 && "${1}" != '--' ]]; do # For each function argument until a '--'.
    return_code=0
    # Intercept failure and store return code in variable (needed by bats).
    process-long-option "${1}" \
      || return_code=${?}

    # Argument is a option with an issue, exit with error code.
    [[ ${return_code} -eq 1 ]] && return 1

    if [[ ${return_code} -eq 2 ]]; then
      # Argument is not a long option, try to process it as short option.
      return_code=0
      # Intercept failure and store return code in variable (needed by bats).
      process-short-options "${1}" \
        || return_code=${?}

      # Argument is a option with an issue, exit with error code.
      [[ ${return_code} -eq 1 ]] && return 1

      # Argument is not an option, store it for future use.
      [[ ${return_code} -eq 2 ]] && arguments+=("${1}")
    fi

    # Discard processed value for ${@}.
    shift
  done

  # Handle arguments after '--'
  [[ "${1}" = '--' ]] && shift && arguments+=("${@}")

  # For each mandatory argument, test its presence.
  for option_name in "${allowed_options[@]}"; do
    # Build the option presence test regular expression.
    cleaned_option_name="${option_name%[+*]}"

    # Test if option is mandatory
    if [[ "${cleaned_option_name}+" = "${option_name}" ]]; then
      if ! in-list "${cleaned_option_name}" "${processed_options[@]}"; then
        cecho 'ERROR' "Error: --${cleaned_option_name} is missing." >&2
        return 1
      fi
    fi
  done

  return 0
} # process-options()
