#!/usr/bin/env bash
# @file src/download.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Download content from a URL and write it to `/dev/stdout`.
# @description
#   `download` uses `curl` or `wget` to download a URL and writes
#   its contents to `/dev/stdout` or to the specified file path.

# shellcheck source-path=SCRIPTDIR
source "${BASH_SOURCE[0]%/*}/cecho.bash"
source "${BASH_SOURCE[0]%/*}/in-list.bash"
source "${BASH_SOURCE[0]%/*}/check-binary.bash"
source "${BASH_SOURCE[0]%/*}/process-options.bash"

# @description
#   Download content from a URL and write it to `/dev/stdout`.
#   `download` use `curl` or `wget` to download a URL contents and write
#   these data to `/dev/stdout` or to the specified file path.
#
# @example
#   source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/download.bash"
#   download --url=https://www.monip.org/
#
# @option -q | --quiet Reduce output to stderr to the bare minimum.
# @option -v | --verbose Enable verbose mode.
# @option -w | --wget Force using `wget`.
# @option -c | --curl Force using `curl`.
# @option --url=<url> Set the URL to fetch (alternative to setting **$1**).
# @option --output-path=<path> Set where to store the downloaded contents (default to `/dev/stdout`)
# @option --user-agent=<user-agent> Allow to set a custom user-agent.
# @arg $1 string The URL to fetch (alternative to using **--url=\<url\>**)
#
# @exitcode 0 If the download is successful.
# @exitcode 1 If no URL is provided.
# @exitcode 1 If too many arguments provided.
# @exitcode 1 If both argument and --url provided.
# @exitcode 1 If the download failed.
#
# @stdout The first found binary absolute path, as outputted by `command -v`.
# @stderr Verbose mode messages, when enabled.
# @stderr Error if no URL is provided.
# @stderr Error if too many arguments provided.
# @stderr Error if both argument and --url provided.
# @stderr Error if the download failed.
#
# @see [cecho](./cecho.md#cecho)
# @see [check-binary](./check-binary.md#check-binary)
# @see [process-options](./process-options.md#process-options)
function download() {
  local quiet=0
  local q=0
  local verbose=0
  local v=0
  local curl=0
  local c=0
  local wget=0
  local w=0
  local url=''
  local output_path=''
  local outputPath=''
  local user_agent=''
  local userAgent=''
  local cookies=''

  local binary_path
  local binary
  local command_line=()
  local binary_check="wget;curl"

  local allowed_options=('q' 'quiet' 'v' 'verbose' 'w' 'wget' 'c' 'curl')

  allowed_options+=('url&' 'output-path&' 'outputPath&')
  allowed_options+=('user-agent&' 'userAgent&' 'cookies&')

  local arguments=()

  # Detect if quiet mode is enabled, to allow for process-optins silencing.
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
  fd_target='&2'
  ((quiet)) && fd_target='/dev/null'
  eval "exec ${error_fd}>${fd_target}"

  local verbose_fd
  verbose_fd=9
  while ((++verbose_fd < 200)); do
    # shellcheck disable=SC2188 # Ignore a file descriptor availability test.
    ! <&"${verbose_fd}" && break
  done 2> '/dev/null'
  fd_target='/dev/null'
  ((verbose)) && fd_target='&2'
  eval "exec ${verbose_fd}>${fd_target}"
  cecho "DEBUG" "Debug: Verbose mode enabled." >&"${verbose_fd-2}"

  # Function closing error redirection file descriptors.
  # to be called before exiting this function.
  close-fds() { eval "exec ${error_fd-}>&- ${verbose_fd-}>&-"; }

  # Call the process-options function:
  if ! process-options "${allowed_options[*]}" ${@+"$@"} 2>&"${error_fd}"; then
    close-fds
    return 1
  fi

  if [[ -z "${url}" && "${#arguments[@]}" -eq 1 ]]; then
    url="${arguments[0]}"
    # Remove URL from arguments.
    arguments=("${arguments[@]:1}")
  elif [[ -n "${url}" && "${#arguments[@]}" -eq 1 ]]; then
    # Exit with error if both --url and $1 are used.
    cecho 'ERROR' "Error: either provide URL via --url or \$1, not both." >&"${error_fd}"
    close-fds
    return 1
  fi

  if [[ "${#arguments[@]}" -ne 0 ]]; then
    cecho 'ERROR' "Error: ${FUNCNAME[0]} accept at most one argument, or --url option." >&"${error_fd}"
    close-fds
    return 1
  fi

  if [[ -z "${url}" ]]; then
    cecho 'ERROR' "Error: ${FUNCNAME[0]} requires URL." >&"${error_fd}"
    close-fds
    return 1
  fi

  quiet=$((quiet + q))
  verbose=$((verbose + v))
  wget=$((wget + w))
  curl=$((curl + c))

  # Add support for deprecated arguments
  [[ -z "${output_path}" ]] && output_path="${outputPath}"
  [[ -z "${user_agent}" ]] && user_agent="${userAgent}"

  # If no target specified, output on stdout.
  # Warning: redirecting output to "grep --max-count=1" will trigger an error.
  [[ -z "${output_path}" ]] && output_path='-'

  cecho 'INFO' "Info: download: downloading '${url}' to '${output_path}'." >&"${verbose_fd}"

  # Process download command forcing
  [[ "${wget}" -ne 0 ]] && binary_check='wget'
  [[ "${curl}" -ne 0 ]] && binary_check='curl'

  cecho 'INFO' "Info: download: checking for ${binary_check//;/ or }." >&"${verbose_fd}"

  # Check for wget or curl presence,
    # Exit with error if check-binary failed.
  if ! binary_path="$(check-binary "${binary_check}" "${binary_check%;*}")"; then
    close-fds
    return 1
  fi

  # Compute binary_path basename.
  binary="${binary_path##*/}"

  # Build command line according to detected binary.
  if [[ "${binary}" = 'curl' ]]; then
    # Curl is used.
    cecho 'INFO' "Info: download: using curl." >&"${verbose_fd}"

    # --insecure: ignore SSL errors.
    # --location: follow redirects.
    command_line+=('curl' '--insecure' '--location' '--fail')
    command_line+=('--silent')
    [[ "${verbose}" -ne 0 ]] && command_line+=('--verbose')
    [[ -n "${cookies}" ]] && command_line+=("--cookie" "${cookies}")
    [[ -n "${user_agent}" ]] && command_line+=("--user-agent" "${user_agent}")
    [[ -n "${output_path}" ]] && command_line+=("--output" "${output_path}")
    command_line+=("${url}")
  else
    # Wget is used.
    cecho 'INFO' "Info: download: using wget." >&"${verbose_fd}"

    # --no-check-certificate: ignore SSL errors.
    # --append-output=/dev/stderr: Prevent the creation of wget-log files.
    command_line+=('wget' '--no-check-certificate')
    command_line+=('--append-output=/dev/stderr')
    [[ "${verbose}" -eq 0 ]] && command_line+=('--quiet')
    [[ "${verbose}" -ne 0 ]] && command_line+=('--no-verbose')
    [[ -n "${cookies}" ]] && command_line+=("--header=Cookie: ${cookies}")
    [[ -n "${user_agent}" ]] && command_line+=("--user-agent=${user_agent}")
    [[ -n "${output_path}" ]] && command_line+=("--output-document=${output_path}")
    command_line+=("${url}")
  fi

  # Run the command line.
  cecho 'INFO' "Info: download: calling { ${command_line[*]} }" >&"${verbose_fd}"
  if "${command_line[@]}"; then
    cecho 'SUCCESS' "Info: download succeed." >&"${verbose_fd}"
  else
    cecho 'ERROR' "Error: download failed." >&"${error_fd}"

    # If output path is a file, and file exists,
    if [[ "${output_path}" != '-' &&
      "${output_path}" != '/dev/stdout' &&
      -e "${output_path}" ]]; then
      # Remove incomplete downloaded file.
      rm "${output_path}"
    fi

    close-fds
    return 1
  fi

  close-fds
  return 0
}
