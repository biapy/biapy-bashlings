#!/usr/bin/env bash
# Legacy alias for check-binary function.

source "${BASH_SOURCE[0]%/*}/check-binary.bash"

# check-binary alias.
function check_binary() {
  check-binary "${@}"
  return
}
