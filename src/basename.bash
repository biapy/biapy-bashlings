#!/usr/bin/env bash
# @file basename.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Strip directory from filenames.
# @description
#     basename print filename with any leading directory components removed.

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
#
# @exitcode 0 If successful.
# @exitcode 1 If argument is missing or more than one argument given.
function basename() {

  [[ ${#} -ne 1 ]] && return 1

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
