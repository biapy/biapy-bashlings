#!/usr/bin/env bash
# @file src/basename.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Strip directory from filenames.
# @description
#     basename print filename with any leading directory components removed.

source "${BASH_SOURCE[0]%/*}/cecho.bash"

# @description Strip directory from filenames.
#
# @example
#     source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/basename.bash"
#     file_path="../path/to/some/file"
#     file_basename="$( basename "${file_path}" )"
#
# @arg $1 string A filename to strip.
#
# @stdout The filename without any leading directory components.
# @stderr Error if the argument is missing or more than one argument is given.
#
# @exitcode 0 If successful.
# @exitcode 1 If argument is missing or more than one argument given.
#
# @see cecho
function basename() {
  # Accept one and only one argument.
  if [[ ${#} -ne 1 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} must have one and only one argument." >&2
    return 1
  fi

  case "$(uname)" in
  'Linux')
    command basename -z -- "${@}" |
      command tr -d '\0'
    ;;
  'Darwin' | *)
    command basename -- "${@}"
    ;;
  esac

  return ${?}
} # basename()
