#!/usr/bin/env bash
# @file src/available-fd.bash
# @author [Grisha Levit](https://stackoverflow.com/users/1072229/grisha-levit)
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Find first unused file descriptor (fd) (for `bash` < 4.1 (e.g. macOS)).
# @description
#   `available-fd` looks for an unused file descriptor and output its number
#   on stdout.

# shellcheck source-path=SCRIPTDIR
source "${BASH_SOURCE[0]%/*}/cecho.bash"

# @description
#   `available-fd` looks for an unused file descriptor (fd) in the range 10 to
#   200 and output its number on stdout.
#   This function is useful for `bash` < 4.1 (e.g. macOS).
#
# @example
#   source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/available-fd.bash"
#   error_fd="$(available-fd || echo -n '2')"; then
#   fd_target='&2'
#   ((quiet)) && fd_target='/dev/null'
#   eval "exec ${error_fd}>${fd_target}"
#
# @exitcode 0 If an available fd is found.
# @exitcode 1 If no fd between 10 and 200 is available.
# @exitcode 2 If argument present.
#
# @stdout The available file descriptor number.
#
# @stderr Error if an argument is present.
#
# @see [cecho](./cecho.md#cecho).
# @see [How to find next available file descriptor in Bash?](https://stackoverflow.com/questions/41603787/how-to-find-next-available-file-descriptor-in-bash/41626332#41626332)
function available-fd() {
  # Requires at least one argument.
  if [[ ${#} -ne 0 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} does not accept arguments." >&2
    return 2
  fi

  # Detect OS maximum fd count.
  max_fd_count="$(ulimit -n)"

  # Limit max_fd count to 200, for an acceptable limit.
  ((max_fd_count > 200)) && max_fd_count=200

  # See:
  local checked_fd=9
  while ((++checked_fd <= max_fd_count)); do
    # shellcheck disable=SC2188 # Ignore a file descriptor availability test.
    if ! <&"${checked_fd}"; then
      # fd is available.
      echo -n "${checked_fd}"
      return 0
    fi
  done 2> '/dev/null'

  return 1
}
