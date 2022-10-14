#!/usr/bin/env bash

# Get the basename of a path (multi-plateform version)
# Print the result on &1 if found.
#
# @param string $path A path.
#
# @return A return code..
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
