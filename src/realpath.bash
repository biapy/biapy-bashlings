#!/usr/bin/env bash
# @file src/realpath.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Resolve the real absolute path.
# @description
#     realpath resolve a relative path or a symbolic link to its real absolute
#     path.

# shellcheck source-path=SCRIPTDIR
source "${BASH_SOURCE[0]%/*}/cecho.bash"

# @description Resolve the real absolute path.
#
# @example
#     source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/realpath.bash"
#     file_path="../relative/path"
#     file_realpath="$( realpath "${file_path}" || echo "${file_path}" )"
#
# @arg $1 string A path to resolve.
#
# @exitcode 0 If successful.
# @exitcode 1 If argument is missing or more than one argument given.
# @exitcode 1 If realpath not found.
#
# @stdout The resolved absolute path, or empty string if realpath not found.
# @stderr Error if argument is missing or more than one argument given.
#
# @see [cecho](./cecho.md#cecho)
function realpath() {
  # Accept one and only one argument.
  if [[ ${#} -ne 1 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} must have one and only one argument." >&2
    return 1
  fi

  local realpath=""

  case "$(uname)" in
    'Linux')
      realpath="$(
        readlink -f -- "${1}" \
          || /usr/bin/realpath -- "${1}" 2> '/dev/null'
      )"
      ;;
    'Darwin')
      # Use python to find a realpath similar to the linux one.
      # See [Bash script absolute path with OS X](https://stackoverflow.com/questions/3572030/bash-script-absolute-path-with-os-x)
      # If a pure bash solution exists, please make a pull request.
      python="$(
        type -p 'python3' 2> '/dev/null' \
          || type -p 'python' 2> '/dev>/null'
      )"
      realpath="$(
        stat -f '%N' -- "${1}" 2> '/dev/null' \
          || [[ -n "${python}" ]] \
          && "${python}" 2> '/dev/null' << EOF
import os
import sys
print(os.path.realpath(u"${1}"))
EOF
      )"
      ;;
    *)
      realpath="$(
        /usr/bin/realpath -- "${1}" 2> '/dev/null'
      )"
      ;;
  esac

  # If realpath is not found, return with error.
  [[ -z "${realpath}" ]] && return 1

  echo -n "${realpath}"
  return 0
} # realpath
