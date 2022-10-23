#!/usr/bin/env bash

# Get the absolute path for a file or directory.
# Print its path on &1 if found.
#
# @param string $path A relative path.
#
# @return ${realpath} A absolute path.
function realpath() {
  [[ ${#} -ne 1 ]] && return 1

  local realpath

  case "$(uname)" in
  'Linux')
    realpath="$(readlink -f -- "${1}")"
    ;;
  'Darwin')
    realpath="$(stat -f '%N' -- "${1}")"
    ;;
  *)
    realpath="$(realpath -- "${1}")"
    ;;
  esac

  echo -n "${realpath}"
  return 0
} # realpath
