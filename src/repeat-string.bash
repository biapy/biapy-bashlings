#!/usr/bin/env bash
# @file src/repeat-string.bash
# @author [gniourf_gniourf](https://stackoverflow.com/users/1815797/gniourf-gniourf)
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Repeat a string N times.
# @description
#   `repeat-string` output given string repeated N times.

# shellcheck source-path=SCRIPTDIR
source "${BASH_SOURCE[0]%/*}/cecho.bash"

# @description
#   Repeat a string N times.
#
# @example
#   source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/repeat-string.bash"
#   repeat-string 40 '-*'
#
# @arg $1 integer The number of times the given string should be repeated.
# @arg $2 string A string to be repeated.
#
# @exitcode 0 If the string is repeated successfully.
# @exitcode 1 If an argument is missing or more than two arguments given.
# @exitcode 2 If first argument is not a integer.
#
# @stdout The `$2` string repeated `$1` times.
#
# @stderr Error if an argument is missing or more than two arguments given.
# @stderr Error if first argument is not a integer.
#
# @see [cecho](./cecho.md#cecho)
# @see [How can I repeat a character in Bash?](https://stackoverflow.com/questions/5349718/how-can-i-repeat-a-character-in-bash/23978341#23978341)
function repeat-string() {
  # Accept one and only one argument.
  if [[ ${#} -ne 2 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} requires two and only two arguments." >&2
    return 1
  fi

  local quantity="${1}"
  local repeated="${2}"
  local spacing=""

  # Ensure quantity is an integer
  if [[ -z "${quantity}" || ! "${quantity}" =~ ^[0-9]+$ ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]}'s first argument is not an integer." >&"${error_fd-2}"
    return 2
  fi

  # Use printf to create an empty string with $quantity spaces.
  # shellcheck disable=SC2183
  printf -v 'spacing' '%*s' "${quantity}"

  # Replace the $quantity spaces by the string to be repeated.
  echo -n "${spacing// /${repeated}}"

  return 0
}
