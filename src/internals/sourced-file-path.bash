#!/usr/bin/env bash
# @file src/internals/sourced-file-path.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Compute sourced file path from a bash source (or dot) command.
# @description
#   `sourced-file-path` is a sub-function of `assemble-sources` that compute
#   a source command sourced file path.
# @see assemble-sources

source "${BASH_SOURCE[0]%/*}/../cecho.bash"
source "${BASH_SOURCE[0]%/*}/../realpath.bash"
source "${BASH_SOURCE[0]%/*}/../process-options.bash"

# @description Get sourced file from source (or dot) command.
#
# @example
#     source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/internals/sourced-file-path.bash"
#     sourced_file="$(
#         sourced-file-path 'source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/cecho.bash"'
#       )"
#
# @arg --debug bool Enable debug output.
# @arg --origin string The file in which the source command is found.
# @arg $1 string A Bash source or . (dot) include command.
#
# @stdout Sourced file relative path to source command file.
# @stderr Error if invalid option is given.
# @stderr Error if argument is missing or too many arguments given.
# @stderr Error if source command can't be parsed.
# @stderr Error if sourced file does not exists.
#
# @exitcode 0 on success.
# @exitcode 1 if invalid option is given.
# @exitcode 1 if argument is missing or too many arguments given.
# @exitcode 1 if source command can't be parsed.
# @exitcode 1 if sourced file does not exists.
function sourced-file-path {
  local allowed_options=( 'debug' 'origin&' )
  # Declare option variables as local.
  local arguments=()
  local origin=''
  local debug=0

  # Call the process-options function:
  if ! process-options "${allowed_options[*]}" "${@}"; then
    [[ "${debug}" -ne 0 ]] && cecho "DEBUG" "Debug: ${FUNCNAME[0]} received an invalid option." >&2
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
  if [[ -z "${file_realpath}" ]]; then
    cecho 'ERROR' "Error: sourced file '${file}' does not exists." >&2
    return 1
  elif [[ ! -e "${file_realpath}" ]]; then
    cecho 'ERROR' "Error: sourced file '${file}'(real path '${file_realpath}') does not exists." >&2
    return 1
  fi

  # Output file realpath and return success if file exists.
  [[ "${debug}" -ne 0 ]] && cecho 'DEBUG' "Debug: sourced file realpath is '${file_realpath}'" >&2
  echo "${file_realpath}"
  return 0
}
