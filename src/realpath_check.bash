#!/usr/bin/env bash
# @file src/realpath_check.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Legacy alias for realpath-check function.
# @description
#     Allow to call `realpath-check` by using the legacy name `realpath_check`.

source "${BASH_SOURCE[0]%/*}/realpath-check.bash"

# @description Resolve a real absolute path and check its existance.
# If the file does not exists, display an error message and return error.
# Print its absolute real path on stdout if found.
#
# @deprecated
#
# @see realpath-check
function realpath_check() {
  realpath-check "${@}"
  return
}
