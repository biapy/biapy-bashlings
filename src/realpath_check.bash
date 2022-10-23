#!/usr/bin/env bash
# Legacy alias for realpath-check function.

source "${BASH_SOURCE[0]%/*}/realpath-check.bash"

# realpath-check alias.
function realpath_check() {
  realpath-check "${@}"
  return
}
