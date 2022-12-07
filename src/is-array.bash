#!/usr/bin/env bash
# @file src/is-array.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Test if a variable is an array.
# @description
#   `is-array` tests if given variable is an array.

# shellcheck source-path=SCRIPTDIR
source "${BASH_SOURCE[0]%/*}/cecho.bash"

# @description
#   Test if given string is the name of a variable storing an array.
#
#   #### Environment
#
#   * **$variable** The variable to be tested.
#
# @example
#   source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/is-array.bash"
#   example_list=( 'test' 'second text' 10 11 )
#   is-array 'example_list[@]}' && 'example_list is an array'
#
#
# @arg $1 string The name of the variable checked to be an array.
#
# @exitcode 0 If variable is a array.
# @exitcode 1 If variable is not an array, or is not set.
#
# @stderr Display an error if $1 is missing.
#
# @see [cecho](./cecho.md#cecho)
function is-array() {
  # Must have at least one argument.
  if [[ ${#} -ne 1 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} requires one and only one argument." >&2
    return 1
  fi

  local variable_name="${1-}"
  local declaration
  local array_check_regex

  # Check is variable is an array using declare -p.
  declaration="$(declare -p "${variable_name}" 2> '/dev/null')"
  array_check_regex="^declare -a ${variable_name}='?\("

  [[ "${declaration}" =~ ${array_check_regex} ]]
  return "${?}"

}
