#!/usr/bin/env bash
# @file realpath_check.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Legacy alias for realpath-check function.
# @description
#     Allow to call `realpath-check` by using the legacy name `realpath_check`.

source "${BASH_SOURCE[0]%/*}/realpath-check.bash"

# @description Resolve a real absolute path and check its existance.
# If the file does not exists, display an error message and return error.
# Print its absolute real path on stdout if found.
#
# @example
#     source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/realpath_check.bash"
#     file_path="../relative/path"
#     if file_realpath="$( realpath_check "${file_path}" )"; then
#       echo "File found. processing..."
#     else
#       exit 1
#     fi
#
# @arg -q | --quiet Disable the error message.
# @arg -e | --exit Enable exiting on failure.
# @arg $1 string A path to resolve.
#
# @stdout The resolved absolute path.
#
# @exitcode 0 If successful.
# @exitcode 1 If the path does not exists, an argument is missing or more
#   than one argument given.
#
# @deprecated
#
# @see realpath-check
function realpath_check() {
  realpath-check "${@}"
  return
}
