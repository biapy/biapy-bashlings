#!/usr/bin/env bash

source 'cecho.bash'
source 'basename.bash'
source 'check_binary.bash'
source 'processOptions.bash'

# Download content from a URL.
# if outputPath is not specified, output the content on stdout.
#
# @param bool $quiet 1 to quiet output.
# @param bool $verbose 1 to enable verbose output.
# @param string $url The fetched URL.
# @param string $outputPath an optionnal output path.
# @param string $userAgent an optionnal User Agent string.
#
# @return 0 on success, 1 on failure.
function download() {
  local quiet=0
  local verbose=0
  local url=''
  local outputPath=''
  local userAgent=''
  local cookies=''

  local binaryPath
  local binary
  local commandLine=()

  local allowedOptions=('quiet' 'verbose' 'url+' 'outputPath' 'userAgent' 'cookies')

  ### Process function options.
  processOptions "${allowedOptions[*]}" "${@}" || return 1

  [[ "${verbose}" -ne 0 ]] && cecho 'blue' "Info: download: downloading '${url}' to '${outputPath}'." >&2

  [[ "${verbose}" -ne 0 ]] && cecho 'blue' "Info: download: checking for wget or curl." >&2

  # Check for wget or curl presence.
  binaryPath="$(check_binary 'wget;curl' 'wget')"
  binary="$(basename "${binaryPath}")"

  # If no target specified, output on stdout.
  # Warning: redirecting output to "grep --max-count=1" will trigger an error.
  [[ -z "${outputPath}" || "${outputPath}" = '-' ]] && outputPath='-'

  # Build command line according to detected binary.
  if [[ "${binary}" = 'curl' ]]; then
    # Curl is used.
    [[ "${verbose}" -ne 0 ]] && cecho 'blue' "Info: download: using curl." >&2

    # --insecure: ignore SSL errors.
    # --location: follow redirects.
    commandLine+=('curl' '--insecure' '--location')
    commandLine+=('--silent')
    [[ "${verbose}" -ne 0 ]] && commandLine+=('--verbose')
    [[ -n "${cookies}" ]] && commandLine+=("--cookie=${cookies}")
    [[ -n "${userAgent}" ]] && commandLine+=("--user-agent=${userAgent}")
    [[ -n "${outputPath}" ]] && commandLine+=("--output=${outputPath}")
    commandLine+=("${url}")
  else
    # Wget is used.
    [[ "${verbose}" -ne 0 ]] && cecho 'blue' "Info: download: using wget." >&2

    # --no-check-certificate: ignore SSL errors.
    # --append-output=/dev/stderr: Prevent the creation of wget-log files.
    commandLine+=('wget' '--no-check-certificate')
    commandLine+=('--append-output=/dev/stderr')
    [[ "${verbose}" -eq 0 ]] && commandLine+=('--quiet')
    [[ "${verbose}" -ne 0 ]] && commandLine+=('--no-verbose')
    [[ -n "${cookies}" ]] && commandLine+=("--header=Cookie: ${cookies}")
    [[ -n "${userAgent}" ]] && commandLine+=("--user-agent=${userAgent}")
    [[ -n "${outputPath}" ]] && commandLine+=("--output-document=${outputPath}")
    commandLine+=("${url}")
  fi

  # Run the command line.
  [[ "${verbose}" -ne 0 ]] && cecho 'blue' "Info: download: calling { ${commandLine[*]} }" >&2
  if "${commandLine[@]}"; then
    [[ "${verbose}" -ne 0 ]] && cecho 'green' "Info: download succeed." >&2
  else
    [[ "${quiet}" -eq 0 ]] && cecho 'red' "Error: download failed." >&2

    # Remove incomplete downloaded file.
    [[ "${outputPath}" != '-' && "${outputPath}" != '/dev/stdout' && -e "${outputPath}" ]] && rm "${outputPath}"

    return 1
  fi

  return 0
} # download()
