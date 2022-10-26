#!/usr/bin/env bash
# @file check-binary.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Check for the presence of a binary in $PATH.
# @description
#     basename print filename with any leading directory components removed.

source "${BASH_SOURCE[0]%/*}/cecho.bash"

# @description
#   Check for the presence of one or more binaries in PATH.
#   If more than one binary is looked for, output the first found binary
#   absolute path and exit without error.
#
# @example
#   source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/check-binary.bash"
#   check-binary "wget;curl" "wget" >'/dev/null' || exit 1
#
# @arg $1 string A semicolon separated list of binary names.
# @arg $2 string The binary's package name.
#
# @stdout The first found binary absolute path, as outputed by `command -v`.
# @stderr An colored error message recommending the installation of $2 package.
#
# @see cecho
#
# @exitcode 0 If binary is found in PATH.
# @exitcode 1 If binary is not found in PATH.
function check-binary() {
  [[ ${#} -ne 2 ]] && exit 1

  local primary
  local binaries
  local binary

  primary="${1%%;*}"
  binaries=()

  read -d ';' -r -a 'binaries' <<<"${1}"

  # Test the binary presence.
  for binary in "${binaries[@]}"; do
    if type "${binary}" &>'/dev/null'; then
      command -v "${binary}"
      return 0
    fi
  done

  cecho 'ERROR' "Error: '${primary}' is missing. Please install package '${2}'." >&2
  return 1
} # check-binary()
