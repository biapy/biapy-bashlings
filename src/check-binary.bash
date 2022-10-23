#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/cecho.bash"

# Check if a binary is present. Print its path on &1 if found.
#
# @param string $binary The binaries to check, separated by ;.
# @param string $package The package the binary come from.
#
# @return Exit with error if the binary is missing.
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
  exit 1
} # check-binary()