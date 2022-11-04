#!/usr/bin/env bash
# @file src/download.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Download content from a URL and write it to `/dev/stdout`.
# @description
#   `download` use `curl` or `wget` to download a URL contents and write
#   these data to `/dev/stdout` or to the specified file path.

source "${BASH_SOURCE[0]%/*}/cecho.bash"
source "${BASH_SOURCE[0]%/*}/basename.bash"
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
# @arg -q | --quiet Reduce output to stderr to the bare minimum.
# @arg -v | --verbose Enable verbose mode.
# @arg --url=<url> (required) Set the URL to fetch.
# @arg --output-path=<path> Set where to store the downloaded contents (default to `/dev/stdout`)
# @arg --user-agent=<user-agent> Allow to set a custom user-agent.
#
# @stdout The first found binary absolute path, as outputed by `command -v`.
# @stderr Verbose mode messages, when enabled.
# @stderr Error if no URL is provided.
# @stderr Error if the download failed.
#
# @exitcode 0 If the download is successful.
# @exitcode 1 If no URL is provided.
# @exitcode 1 If the download failed.
#
# @see cecho
# @see basename
# @see check-binary
# @see process-options
function download() {
  local q=0
  local quiet=0
  local v=0
  local verbose=0
  local url=''
  local outputPath=''
  local userAgent=''
  local output_path=''
  local user_agent=''
  local cookies=''

  local binary_path
  local binary
  local commandLine=()

  local allowedOptions=( 'q' 'quiet' 'v' 'verbose' 'url+' \
    'output-path&' 'outputPath&' 'user-agent&' 'userAgent&' 'cookies&')

  # Detect if quiet mode is enabled, to allow for process-optins silencing.
  in-list "(-q|--quiet)" "${@}" && quiet=1
  in-list "(-v|--verbose)" "${@}" && verbose=1

  ### Process function options.
  if [[ "${quiet}" -ne 0 && "${verbose}" -eq 0 ]]; then
    process-options "${allowedOptions[*]}" "${@}" > '/dev/null' 2>&1 || return 1
  else
    process-options "${allowedOptions[*]}" "${@}" || return 1
  fi

  quiet=$((quiet + q))
  verbose=$((verbose + v))

  # Add support for deprecated arguments
  [[ -z "${output_path}" ]] && output_path="${outputPath}"
  [[ -z "${user_agent}" ]] && user_agent="${userAgent}"

  # If no target specified, output on stdout.
  # Warning: redirecting output to "grep --max-count=1" will trigger an error.
  [[ -z "${output_path}" ]] && output_path='-'

  [[ "${verbose}" -ne 0 ]] \
    && cecho 'INFO' "Info: download: downloading '${url}' to '${output_path}'." >&2

  [[ "${verbose}" -ne 0 ]] \
    && cecho 'INFO' "Info: download: checking for wget or curl." >&2

  # Check for wget or curl presence.
  binary_path="$(check-binary 'wget;curl' 'wget')"
  binary="$(basename "${binary_path}")"

  # Build command line according to detected binary.
  if [[ "${binary}" = 'curl' ]]; then
    # Curl is used.
    [[ "${verbose}" -ne 0 ]] && cecho 'INFO' "Info: download: using curl." >&2

    # --insecure: ignore SSL errors.
    # --location: follow redirects.
    commandLine+=('curl' '--insecure' '--location')
    commandLine+=('--silent')
    [[ "${verbose}" -ne 0 ]] && commandLine+=('--verbose')
    [[ -n "${cookies}" ]] && commandLine+=("--cookie=${cookies}")
    [[ -n "${user_agent}" ]] && commandLine+=("--user-agent=${user_agent}")
    [[ -n "${output_path}" ]] && commandLine+=("--output=${output_path}")
    commandLine+=("${url}")
  else
    # Wget is used.
    [[ "${verbose}" -ne 0 ]] && cecho 'INFO' "Info: download: using wget." >&2

    # --no-check-certificate: ignore SSL errors.
    # --append-output=/dev/stderr: Prevent the creation of wget-log files.
    commandLine+=('wget' '--no-check-certificate')
    commandLine+=('--append-output=/dev/stderr')
    [[ "${verbose}" -eq 0 ]] && commandLine+=('--quiet')
    [[ "${verbose}" -ne 0 ]] && commandLine+=('--no-verbose')
    [[ -n "${cookies}" ]] && commandLine+=("--header=Cookie: ${cookies}")
    [[ -n "${user_agent}" ]] && commandLine+=("--user-agent=${user_agent}")
    [[ -n "${output_path}" ]] && commandLine+=("--output-document=${output_path}")
    commandLine+=("${url}")
  fi

  # Run the command line.
  [[ "${verbose}" -ne 0 ]] && cecho 'INFO' "Info: download: calling { ${commandLine[*]} }" >&2
  if "${commandLine[@]}"; then
    [[ "${verbose}" -ne 0 ]] && cecho 'SUCCESS' "Info: download succeed." >&2
  else
    [[ "${quiet}" -eq 0 ]] && cecho 'ERROR' "Error: download failed." >&2

    # Remove incomplete downloaded file.
    [[ "${output_path}" != '-' \
      && "${output_path}" != '/dev/stdout' \
      && -e "${output_path}" ]] \
        && rm "${output_path}"

    return 1
  fi

  return 0
} # download()
