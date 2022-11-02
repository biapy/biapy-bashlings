#!/usr/bin/env bash
# @file realpath.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Resolve the real absolute path.
# @description
#     realpath resolve a relative path or a symbolic link to its real absolute
#     path.

# @description Resolve the real absolute path.
#
# @example
#     source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/realpath.bash"
#     file_path="../relative/path"
#     file_realpath="$( realpath "${file_path}" || echo "${file_path}" )"
#
# @arg $1 string A path to resolve.
#
# @stdout The resolved absolute path, or empty string if realpath not found.
#
# @exitcode 0 If successful.
# @exitcode 1 If argument is missing or more than one argument given.
# @exitcode 1 If realpath not found.
function realpath() {
  [[ ${#} -ne 1 ]] && return 1

  local realpath

  case "$(uname)" in
  'Linux')
    realpath="$( readlink -f -- "${1}" || realpath -- "${1}" )"
    ;;
  'Darwin')
    realpath="$( stat -f '%N' -- "${1}" )"
    ;;
  *)
    realpath="$( realpath -- "${1}" )"
    ;;
  esac

  # If realpath is not found, return with error.
  [[ -z "${realpath}" ]] && return 1

  echo -n "${realpath}"
  return 0
} # realpath
