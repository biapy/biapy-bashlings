#!/usr/bin/env bash

source "${BASH_SOURCE[0]%/*}/cecho.bash"
source "${BASH_SOURCE[0]%/*}/realpath.bash"
source "${BASH_SOURCE[0]%/*}/process-options.bash"

# Get sourced file from source command.
#
# @param string $origin The file in which the source command is found.
# @param string $1 A Bash source or . (dot) include command.
# @return 0 on success, 1 on error.
# @stdout Sourced file relative path to source command file.
function sourced-file-path {
  local allowed_options=( 'debug' 'origin' )
  # Declare option variables as local.
  local arguments=()
  local origin=''
  local debug=0

  # Call the process-options function:
  if ! process-options "${allowed_options[*]}" "${@}"; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} received an invalid option.." >&2
    return 1
  fi

  # Accept one and only one argument.
  if [[ ${#arguments[@]} -ne 1 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} must have one and only one argument." >&2
    return 1
  fi

  local source_command
  local file
  local file_realpath
  local cleaned_file
  local input_folder

  source_command="${arguments[0]}"

  [[ "${debug}" -ne 0 ]] && cecho 'DEBUG' "Debug: Extracting file path from source command '${source_command}'." >&2
  file="$(echo "${source_command}" |
    sed --regexp-extended \
      --expression='s#^[[:blank:]]*(source|\.)[[:blank:]]+["'\'']?([^"'\'']*)["'\'']?#\2#' ||
    true)"
  [[ "${debug}" -ne 0 ]] && cecho 'DEBUG' "Debug: Detected file path '${file}'." >&2

  if [[ "${file}" = "${source_command}" ]]; then
    cecho "ERROR" "Error: unable to extract file from command '${source_command}'." >&2
    return 1
  fi

  if [[ -z "${origin}" ]]; then
    [[ "${debug}" -ne 0 ]] && cecho 'DEBUG' "Debug: Sourced file origin was not provided." >&2
    # Origin is not specified, return file path as is.
    echo "${file}"
    return 0
  fi

  input_folder="$( dirname "$( realpath "${origin}" || true )" )"

  if [[ "${file}" =~ ^/ ]]; then
    # Sourced file with absolute path.
    [[ "${debug}" -ne 0 ]] && cecho 'DEBUG' "Debug: Sourced file path is absolute: '${file}'." >&2

    file_realpath="$(realpath "${file}")"
  elif [[ "${file}" =~ ^\$\{BASH_SOURCE\[0\]%/\*\} ]]; then
    # Sourced file with variable parts.
    [[ "${debug}" -ne 0 ]] && cecho 'DEBUG' "Debug: Sourced file starts with variable parts." >&2
    [[ "${debug}" -ne 0 ]] && cecho 'DEBUG' "Debug: Removing variable parts from '${file}'" >&2
    # shellcheck disable=SC2016
    cleaned_file="$(echo "${file}" |
      sed --expression='s#^\${BASH_SOURCE\[0\]%/\*}/##')"
    [[ "${debug}" -ne 0 ]] && cecho 'DEBUG' "Debug: Removal result is '${cleaned_file}'" >&2

    [[ "${debug}" -ne 0 ]] && cecho 'DEBUG' "Debug: Finding realpath for '${input_folder}/${cleaned_file}'" >&2
    file_realpath="$(realpath "${input_folder}/${cleaned_file}")"
  else
    # Sourced file with relative path.
    [[ "${debug}" -ne 0 ]] && cecho 'DEBUG' "Debug: Sourced file path is relative: '${file}'." >&2
    [[ "${debug}" -ne 0 ]] && cecho 'DEBUG' "Debug: Finding realpath for '${input_folder}/${file}'" >&2
    file_realpath="$(realpath "${input_folder}/${file}")"
  fi
  
  # Return failure if file does not exists.
  if [[ ! -e "${file_realpath}" ]]; then
    cecho 'ERROR' "Error: sourced file '${file}'(real path '${file_realpath}') does not exists." >&2
    return 1
  fi

  # Output file realpath and return success if file exists.
  [[ "${debug}" -ne 0 ]] && cecho 'DEBUG' "Debug: sourced file realpath is '${file_realpath}'" >&2
  echo "${file_realpath}"
  return 0
}
