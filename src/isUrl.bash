#!/usr/bin/env bash
# Legacy alias for is-url function.

source "${BASH_SOURCE[0]%/*}/is-url.bash"

# is-url alias.
function isUrl() {
  is-url "${@}"
  return
}
