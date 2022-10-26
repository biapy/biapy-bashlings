#!/usr/bin/env bash
# @file check_binary.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Legacy alias for check-binary function.
# @description
#     Allow to call `check-binary` by using the legacy name `check_binary`.

source "${BASH_SOURCE[0]%/*}/check-binary.bash"

# @description
#   Check for the presence of one or more binaries in PATH.
#   If more than one binary is looked for, output the first found binary
#   absolute path and exit without error.
#
# @example
#   source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/check-binary.bash"
#   check_binary "wget;curl" "wget" >'/dev/null' || exit 1
#
# @see check_binary
#
function check_binary() {
  check-binary "${@}"
  return
}
