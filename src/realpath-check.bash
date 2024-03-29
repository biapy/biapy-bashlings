#!/usr/bin/env bash
# @file src/realpath.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Resolve the real absolute path and check for its existence.
# @description
#     `realpath-check` calls `realpath` to resolve a relative path or a
#     symbolic link to its real absolute path. It then checks for its existence
#     and returns an error code if the path does not exists.

# shellcheck source-path=SCRIPTDIR
source "${BASH_SOURCE[0]%/*}/available-fd.bash"
source "${BASH_SOURCE[0]%/*}/cecho.bash"
source "${BASH_SOURCE[0]%/*}/in-list.bash"
source "${BASH_SOURCE[0]%/*}/process-options.bash"
source "${BASH_SOURCE[0]%/*}/realpath.bash"

# @description Resolve a real absolute path and for check its existence.
#   If the file does not exists, display an error message and return error.
#   Print its absolute real path on stdout if found.
#
# @example
#   source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/realpath-check.bash"
#   file_path="../relative/path"
#   if file_realpath="$( realpath-check "${file_path}" )"; then
#     echo "File found. processing..."
#   else
#     exit 1
#   fi
#
# @option -q | --quiet Disable the error message.
# @option -e | --exit Enable exiting on failure.
# @arg $1 string A path to resolve.
#
# @exitcode 0 If successful.
# @exitcode 1 If the path does not exists, an argument is missing or more
#   than one argument given.
#
# @stdout The resolved absolute path.
# @stderr Error if the argument is missing or more than one argument is given.
# @stderr Error if the path does not exist
#
# @see [realpath](./realpath.md#realpath)
# @see [process-options](./process-options.md#process-options)
# @see [cecho](./cecho.md#cecho)
function realpath-check() {
  local allowed_options=('q' 'quiet' 'e' 'exit')
  # Declare option variables as local.
  local arguments=()
  local q=0
  local quiet=0
  local e=0
  local exit=0

  local fd_target
  local error_fd
  local path=''
  local realpath=''

  # Detect if quiet mode is enabled, to allow for output silencing.
  in-list "(-q|--quiet)" ${@+"$@"} && quiet=1

  # Conditionnal output redirection.
  if error_fd="$(available-fd '2')"; then
    ((quiet)) && fd_target='/dev/null' || fd_target='&2'
    eval "exec ${error_fd-2}>${fd_target-&2}"
  fi

  # Function closing error redirection file descriptors.
  # to be called before exiting this function.
  close-fds() { [[ "${error_fd-2}" -ne 2 ]] && eval "exec ${error_fd}>&-"; }

  # Call the process-options function:
  if ! process-options "${allowed_options[*]}" ${@+"$@"} 2>&"${error_fd}"; then
    close-fds
    return 1
  fi

  # Process short options.
  quiet=$((quiet + q))
  exit=$((exit + e))

  # Accept one and only one argument.
  if [[ ${#arguments[@]} -ne 1 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} requires one and only one argument." >&"${error_fd}"
    close-fds
    return 1
  fi

  path="${arguments[0]-}"

  realpath="$(realpath "${path-}" || true)"

  # Check if realpath is found and exists.
  if [[ -n "${realpath-}" && ! -e "${realpath-}" ]]; then
    # If realpath does not exists, reset the variable.
    realpath=''
  fi

  # If $realpath is empty,
  if [[ -z "${realpath-}" ]]; then
    cecho 'ERROR' "Error: File '${path-}' does not exists." >&"${error_fd}"
    close-fds
    # Exit on error if specified.
    [[ "${exit-0}" -ne 0 ]] && exit 1
    return 1
  fi

  # Output the realpath.
  echo -n "${realpath-}"
  close-fds
  return 0
}
