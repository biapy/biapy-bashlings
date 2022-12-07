#!/usr/bin/env bash
# @file src/realpath.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Resolve the real absolute path.
# @description
#     `realpath` resolves a relative path or a symbolic link to its real
#     absolute path.

# shellcheck source-path=SCRIPTDIR
source "${BASH_SOURCE[0]%/*}/cecho.bash"
source "${BASH_SOURCE[0]%/*}/in-list.bash"

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
# @see [How can I get the behavior of GNU's readlink -f on a Mac?](https://stackoverflow.com/questions/1055671/how-can-i-get-the-behavior-of-gnus-readlink-f-on-a-mac)
# @see [bats-core bats command](https://github.com/bats-core/bats-core/blob/master/bin/bats)
# @see [cecho](./cecho.md#cecho)
function realpath() {
  local pure_bash=0
  # Check if --pure-bash option given.
  if [[ "${1-}" = "--pure-bash" ]]; then
    pure_bash=1
    shift
  fi

  # Accept one and only one argument.
  if [[ ${#} -ne 1 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} requires one and only one argument." >&2
    return 1
  fi

  # Fail on empty argument.
  [[ -z "${1-}" ]] && return 1

  local realpath=""

  if [[ "${pure_bash}" -eq 0 ]] \
      && command -v 'greadlink' > '/dev/null'; then
    realpath="$(greadlink -f -- "${1-}" 2> '/dev/null')"
  elif  [[ "${pure_bash}" -eq 1 ]] \
      || ! realpath="$(readlink -f -- "${1-}" 2> '/dev/null')"; then
    # If readlink -f is not available (e.g. MacOS), use bats-core inspired
    # alternative.
    # Follow up to 40 symbolic links
    local max_symlinks=40
    target="${1-}"
    realpath=""

    # If target exist, trim trailing slashes
    [[ -e "${target%/}" ]] || target=${1%"${1##*[!/]}"}
    # If target is a directory, add trailing slash.
    [[ -d "${target:-/}" ]] && target="${target}/"

    # Check that cd -P work, fail if not.
    cd -P . 2> /dev/null || return 1
    # While symbolic link limit is not broken.
    while [[ "${max_symlinks}" -ge 0 ]] \
            && max_symlinks=$((max_symlinks - 1)); do
      # If target is a filename without path (?)
      if [[ "${target}" != "${target%/*}" ]]; then
        # Ensure path exists.
        case "${target}" in
          /*)
            cd -P "${target%/*}/" 2> '/dev/null' \
              || break
            ;;
          *)
            cd -P "./${target%/*}" 2> '/dev/null' \
              || break
            ;;
        esac
        target="${target##*/}"
      fi

      # If target is not a symbolic link.
      if [[ ! -L "${target}" ]]; then
        # Output result.
        target="${PWD%/}${target:+/}${target}"
        # printf '%s\n' "${target:-/}"
        # return 0
        realpath="${target:-/}"
        break
      fi

      # `ls -dl` format: "%s %u %s %s %u %s %s -> %s\n",
      #   <file mode>, <number of links>, <owner name>, <group name>,
      #   <size>, <date and time>, <pathname of link>, <contents of link>
      # https://pubs.opengroup.org/onlinepubs/9699919799/utilities/ls.html
      link="$(ls -dl -- "${target}" 2> /dev/null)" || break
      target="${link#*" ${target} -> "}"
    done
    # return 1
  fi

  # If realpath is not found, return with error.
  [[ -z "${realpath}" ]] && return 1

  echo -n "${realpath}"
  return 0
}
