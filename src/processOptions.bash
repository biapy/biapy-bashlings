#!/usr/bin/env bash
# @file src/processOptions.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Legacy alias for process-options function.
# @description
#     Allow to call `process-options` by using the legacy name `processOptions`.

source "${BASH_SOURCE[0]%/*}/process-options.bash"

# @description Alternative getopt for functions.
#  Store values in theses global variables:
#  - arguments[] : arguments that does not start by - or are after a '--'.
#  - "${option_name}" : variable named after each argument starting by '--' (e.g. --option_name) or '-' (e.g. -o).
#
#  store allowed --myOption="value" in variable $myOption.
#  store allowed --my-option="value" in variable $my_option.
#  if --myOption or has no value set, set it to 1.
#
# @deprecated
#
# @see process-options
function processOptions() {
  process-options "${@}"
  return
}
