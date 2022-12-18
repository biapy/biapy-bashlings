#!/usr/bin/env bash
# @file src/join-array.bash
# @author [meleu](https://dev.to/meleu)
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Join an array contents with a string separator.
# @description
#   `join-array` converts an array to string by joining its values with given
#   string.

# shellcheck source-path=SCRIPTDIR
source "${BASH_SOURCE[0]%/*}/cecho.bash"

# @description
#   Join an array contents by a string. It is similar to PHP `implode`
#   function.
#   The separator allows for escaped special characters (e.g. `\n` and `\t`)
#   by being pre-processed with `printf '%b'`
#
# @example
#   source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/join-array.bash"
#   declare -a 'example_array'
#   example_array=('Dancing' 'on the tune of' 1 'array contents' )
#   example_string="$(
#     join-array ' ~8~ ' ${example_array[@]+"${example_array[@]}"}
#   )"
#
# @arg $1 string The separator used to join the array contents.
# @arg $@ mixed The contents of the joined array.
#
# @exitcode 0 If the array contents is join successfully.
# @exitcode 1 If an argument is missing.
#
# @stdout The `$@` array contents joined by `$1` separator.
#
# @stderr Error if an argument is missing.
#
# @see [cecho](./cecho.md#cecho).
# @see [PHP implode()](https://www.php.net/manual/function.implode.php).
# @see [How to join() array elements in a bash script](https://dev.to/meleu/how-to-join-array-elements-in-a-bash-script-303a)
function join-array() {
  # Requires at least one argument.
  if [[ ${#} -eq 0 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} requires a separator as first argument." >&2
    return 1
  fi

  # Get separator, process escaped characters & remove it from arguments.
  local separator="${1-}"
  [[ -n "${separator-}" ]] && printf -v 'separator' '%b' "${separator-}"
  shift

  # If array is empty, return empty string.
  if [[ ${#} -eq 0 ]]; then
    return 0
  fi

  # Get first value and remove it from arguments.
  local first_item="${1-}"
  shift

  # Output contents using printf to prevent word splitting
  # (i.e. $IFS in output).
  printf "%s" "${first_item}" "${@/#/${separator}}"
  return
}
