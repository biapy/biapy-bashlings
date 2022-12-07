#!/usr/bin/env bash
# @file src/internals/process-short-options.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Process an argument as a short option (starting with -).
# @description
#   `process-short-options` is a sub-function of `process-options` charged of
#   processing arguments starting with a single dash.

# shellcheck source-path=SCRIPTDIR
# shellcheck source-path=SCRIPTDIR/..
source "${BASH_SOURCE[0]%/*}/../cecho.bash"
source "${BASH_SOURCE[0]%/*}/validate-option.bash"

# @description Try to process argument as short options (starting by -).
#   Short options can be any letter among a-z and A-Z.
#
#   #### Environment
#
#   * **$allowed_options** A list of allowed options names
#     with * suffix if option argument is allowed and + suffix if option
#     argument is required.
#
# @arg $1 string The argument to be processed.
#
# @set o int 1 if o found in short options string.
# @set ... any one letter variables corresponding to accepted short options.
#
# @exitcode 0 if the argument is a supported long option.
# @exitcode 1 if $1 is missing.
# @exitcode 2 if $1 is not a sort option.
# @exitcode 1 if $1 is not an allowed option.
# @exitcode 1 if the option requires an argument and none is provided.
# @exitcode 1 if the option does not support arguments and one is provided.
#
# @stderr Error if the option is not allowed.
#
# @see [validate-option](./validate-option.md#validate-option)
# @see [process-options](../process-options.md#process-options)
function process-short-options() {
  # Accept one and only one argument.
  if [[ ${#} -ne 1 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} requires only one argument." >&2
    return 1
  fi

  # Test if argument is a short option (starts with '-')
  if [[ "${1-}" =~ ^-([a-zA-Z]*)$ ]]; then
    # For each letter in short option, process as separate short option.
    short_options_list="${BASH_REMATCH[1]}"
    for ((option_index = 0; option_index < ${#short_options_list}; option_index++)); do
      # For the time being do not allow arguments for short options.
      option_name="${short_options_list:${option_index}:1}"
      validate-option "${option_name}" || return ${?}
    done

    # Argument processed without error.
    return 0
  fi

  # Argument is not a short option.
  return 2
}
