#!/usr/bin/env bash
# Legacy alias for process-options function.

source "${BASH_SOURCE[0]%/*}/process-options.bash"

# process-options alias.
function processOptions() {
  process-options "${@}"
  return
}
