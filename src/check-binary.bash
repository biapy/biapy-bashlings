#!/usr/bin/env bash
# @file src/check-binary.bash
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
# @exitcode 0 If binary is found in PATH.
# @exitcode 1 If less or more than 2 arguments provided.
# @exitcode 1 If binary is not found in PATH.
#
# @stdout The first found binary absolute path, as outputed by `command -v`.
# @stderr Error if number of arguments is not 2.
# @stderr Error if no binary found, recommending the installation of `$2` package.
#
# @see [cecho](./cecho.md#cecho)
function check-binary() {
  # Accept two and only two arguments.
  if [[ ${#} -ne 2 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} must have two and only two arguments." >&2
    return 1
  fi

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
