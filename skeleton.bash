#!/bin/bash
# @file skeleton.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Bash script skeleton.
# @description
#   `skeleton.bash` is a skeleton to create `bash` scripts regrouping
#   recommendations and examples from various sources.

version='1.0.0'

script_version="Skeleton v${version}"
script_name="${0-##*/}"
# Use dirname to get the script directory, since it allow for missing slash:
# script_dir="$(dirname "${0-}")"

# shellcheck source-path=SCRIPTDIR
source "${BASH_SOURCE[0]%/*}/src/cecho.bash"
source "${BASH_SOURCE[0]%/*}/src/in-list.bash"

# Test if file is sourced.
# See https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
if ! (return 0 2> /dev/null); then
  # Apply The Sharat's recommendations
  # See [Shell Script Best Practices](https://sharats.me/posts/shell-script-best-practices/)
  set -o errexit
  set -o nounset
  set -o pipefail

  if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
  fi
  # cd "${script_dir}"
fi

# @description
#   `skeleton` is a skeleton function to create `bash` scripts regrouping
#   recommendations and examples from various sources.
#
# @option -h | -? | --help Display usage information.
# @option -V | --version Display version.
# @option -q | --quiet Disable error message output.
# @option -v | --verbose Enable verbose mode.
# @option -o <file path> | --ouput=<file path> Set the output path.
#
# @arg $1 string The input file path.
#
# @exitcode 0 If skeleton succeed.
# @exitcode 1 If an unsupported option is used.
# @exitcode 2 If the required arguments are missing.
# @exitcode 3 If --output is missing an argument.
function skeleton() {
  local quiet=0
  local verbose=0
  local input_path=''
  local output_path=''

  # @description
  #   Bashembler usage.
  #
  # @stdout Bashembler usage information.
  function usage() {
    cat << EOF
${script_version}

Skeleton does something.

Usage:

  ${script_name} [ -h | -? | --help ] [ -q | --quiet ] [ -v | --verbose ]
      [ -o <output file> | --output=<output file> ] <input file>

Options:

* -h | -? | --help : Display this message.
* -V | --version   : Display version.
* -q | --quiet     : Disable error output.
* -v | --verbose   : Enable verbose output.

EOF
  }

  # Detect if quiet mode is enabled, to allow for output silencing.
  in-list "(-q|--quiet)" ${@+"$@"} && quiet=1
  in-list "(-v|--verbose)" ${@+"$@"} && verbose=1

  # Conditionnal output redirection.
  # See: https://unix.stackexchange.com/questions/28740/bash-use-a-variable-to-store-stderrstdout-redirection
  local fd_target
  local error_fd
  # For bash < 4.1 (e.g. Mac OS), detect first available file descriptor.
  # See: https://stackoverflow.com/questions/41603787/how-to-find-next-available-file-descriptor-in-bash
  error_fd=9
  while ((++error_fd < 200)); do
    # shellcheck disable=SC2188 # Ignore a file descriptor availability test.
    ! <&"${error_fd}" && break
  done 2> '/dev/null'
  if ((error_fd < 200)); then
    fd_target='&2'
    ((quiet)) && fd_target='/dev/null'
    eval "exec ${error_fd}>${fd_target}"
  else
    error_fd=2
  fi

  # For bash >4.1, the above line can be replaced by:
  # local error_fd
  # if ((quiet)); then
  #   # Discard error messages.
  #   exec {error_fd}> '/dev/null'
  # else
  #   # Display error messages on stderr (&2).
  #   exec {error_fd}>&2
  # fi

  local verbose_fd
  verbose_fd=9
  while ((++verbose_fd < 200)); do
    # shellcheck disable=SC2188 # Ignore a file descriptor availability test.
    ! <&"${verbose_fd}" && break
  done 2> '/dev/null'
  if ((verbose_fd < 200)); then
    fd_target='/dev/null'
    ((verbose)) && fd_target='&2'
    eval "exec ${verbose_fd}>${fd_target}"
    cecho "DEBUG" "Debug: Verbose mode enabled." >&"${verbose_fd-2}"
  else
    verbose_fd=2
  fi

  # Function closing error redirection file descriptors.
  # to be called before exiting this function.
  # Function closing error redirection file descriptors.
  # to be called before exiting this function.
  close-fds() {
    [[ "${error_fd-2}" -ne 2 ]] && eval "exec ${error_fd-}>&-"
    [[ "${verbose_fd-2}" -ne 2 ]] && eval "exec ${verbose_fd-}>&-"
  }
  # For bash >= 4.1 (e.g. not MacOS), use:
  # close-fds() { exec {error_fd}>&- {verbose_fd}>&-; }

  # Options processing.
  # See: https://mywiki.wooledge.org/BashFAQ/035
  while :; do
    case "${1-}" in
      '-h' | '-?' | '--help')
        # Display a usage synopsis.
        usage
        close-fds
        return 0
        ;;
      '-V' | '--version')
        echo "${script_version}"
        close-fds
        return 0
        ;;
      '-v' | '--verbose')
        verbose=1
        ;;
      '-q' | '--quiet')
        quiet=1
        ;;
      '-o' | '--output') # Takes an option argument; ensure it has been specified.
        if [[ -n "${2-}" ]]; then
            output_path="${2-}"
            shift
        else
          cecho 'ERROR' "Error: --file requires an non-empty option argument." >&"${error_fd-2}"
          close-fds
          return 3
        fi
        ;;
      '--output='?*)
        # Delete everything up to "=" and assign the remainder.
        output_path="${1#*=}"
        ;;
      '--output=')          # Handle the case of an empty --file=
        cecho 'ERROR' "Error: --file requires an non-empty option argument." >&"${error_fd-2}"
        close-fds
        return 3
        ;;
      '--')               # End of all options.
        shift
        break
        ;;
      '-'?*)
        cecho 'ERROR' "Error: option '${1}' is not recognized." >&"${error_fd-2}"
        close-fds
        return 1
        ;;
      *)               # Default case: No more options, so break out of the loop.
        break ;;
    esac

    shift
  done

  if [[ ${#} -ne 1 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} accept one and only one argument." >&"${error_fd-2}"
    close-fds
    return 2
  fi

  input_path="${1-}"

  # If no target specified, output on stdout.
  [[ -z "${output_path-}" ]] && output_path='-'
  [[ "${output_path--}" = '-' ]] && output_path='/dev/stdout'

  # Test if output file can be created in given path.
  cecho "DEBUG" "Debug: check if output file can be created in given path." >&"${verbose_fd-2}"
  if [[ "${output_path-}" != "/dev/stdout" &&
        ! -d "$(dirname "${output_path-}")" ]]; then
    cecho "ERROR" "Error: file '${output_path-}' directory does not exists." >&"${error_fd-2}"
    close-fds
    return 1
  fi

  cecho 'DEBUG' "Debug: outputing '${input_path-}' to '${output_path-}'." >&"${verbose_fd-2}"
  cat "${input_path-}" > "${output_path-}"

  close-fds
  return 0
}

# Test if file is sourced.
# See https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
if ! (return 0 2> /dev/null); then
  # File is run as script. Call function as is.
  skeleton "${@}"
  exit ${?}
fi
