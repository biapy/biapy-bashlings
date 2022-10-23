#!/usr/bin/env bash
# Partially inspired by:
# https://stackoverflow.com/questions/37531927/replacing-source-file-with-its-content-and-expanding-variables-in-bash

source "${BASH_SOURCE[0]%/*}/cecho.bash"
source "${BASH_SOURCE[0]%/*}/realpath.bash"
source "${BASH_SOURCE[0]%/*}/process-options.bash"
source "${BASH_SOURCE[0]%/*}/sourced-file-path.bash"

# Read input file line by line, following source and . (dot) commands to
# include sourced content in output.
#
# This function is designed to assemble stand-alone shell scripts from
# splitted development versions.
# @param bool --debug 1 to enable debug mode, 0 to disable.
# @param string --origin=<origin-file-path> The origin shell script file path.
# @param string --input=<input-file-path> The input shell script file path.
# @param string --output=<output-file-path> The output shell script file path.
# @return 1 on error, 0 on success.
function recurse-sources() {
  local allowed_options=( 'debug' 'origin' 'input+' 'output+')
  # Declare option variables as local.
  local arguments=()
  local debug=0
  local origin
  local input
  local output

  local line_count
  local source_command
  local sourced_file

  # Call the process-options function:
  if ! process-options "${allowed_options[*]}" "${@}"; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} received an invalid option.." >&2
    return 1
  fi

  # Accept one and only one argument.
  if [[ ${#arguments[@]} -ne 0 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} must no argument." >&2
    return 1
  fi

  # Test if input file exists.
  if [[ ! -e "${input}" ]]; then
    cecho "ERROR" "Error: file '${input}' does not exists." >&2
    return 1
  fi

  # Test if output file can be created in given path.
  if [[ ! -d "$(dirname "${output}")" ]]; then
    cecho "ERROR" "Error: file '${output}' directory does not exists." >&2
    return 1
  fi

  # If the file is not a sourced file (ie. is the root shellscript),
  if [[ -z "${origin}" ]]; then
    # Initialize output file
    echo -n "" >"${output}"

    # Declare sourced_files list for this function and its recursions.
    local sourced_files=()
  fi

  # Read input file line by line.
  # || [[ -n "${line}" ]] allow to get last line if no new line is added.
  line_count=1
  # shellcheck disable=SC2094
  while IFS='' read -r 'line' || [[ -n "${line}" ]]; do
    # If the file is a sourced file, remove shebang.
    if [[ -n "${origin}" &&
      "${line_count}" -eq 1 &&
      "${line}" =~ ^\#\!
    ]]; then
      [[ "${debug}" -ne 0 ]] && cecho 'DEBUG' "Debug: discarding shebang at line ${line_count} of file '${input}'." >&2
      # Skip shebang.
      continue
    fi

    # Detect if line contains a source command.
    source_command="$(echo "${line}" |
      grep --extended-regexp '^[[:blank:]]*(source|\.)[[:blank:]]')"

    # If line contains a source command, recurse in source.
    if [[ -n "${source_command}" ]]; then
      [[ "${debug}" -ne 0 ]] && cecho 'DEBUG' "Debug: detected source command '${source_command}' at line ${line_count} of file '${input}'." >&2
      # Detect sourced filename.
      sourced_file=""
      # Detect if ogirin is set.
      if [[ -n "${origin}" ]]; then
        # If origin is set, try to get sourced file path relative to origin.
        [[ "${debug}" -ne 0 ]] && cecho 'DEBUG' "Debug: trying to get source file relative to origin '${origin}'." >&2
        if ! sourced_file="$( sourced-file-path --debug="${debug}" \
          --origin="${origin}" \
          "${source_command}"
        )"; then
          # Ensure sourced_file is empty on failure.
          sourced_file=""
        fi
      fi

      # If sourced file path is still not found,
      if [[ -z "${sourced_file}" ]]; then
        # try to get sourced file path relative to input file.
         [[ "${debug}" -ne 0 ]] && cecho 'DEBUG' "Debug: trying to get source file relative to input '${input}'." >&2
        if ! sourced_file="$( sourced-file-path --debug="${debug}" \
          --origin="${input}" \
          "${source_command}"
        )"; then
          cecho "ERROR" "Error: can not resolve command '${source_command}' in file '${input}'." >&2
          return 1
        fi
      fi

      # If the sourced-file-path call is successfull.
      if [[ -n "${sourced_file}" ]]; then
        # Detect the root origin of the assemblage.
        local source_origin="${input}"
        [[ -n "${origin}" ]] && source_origin="${origin}"

        # Check if sourced_file has not been already sourced
        # (ie. is not listed in sourced_files)
        if [[ ! " ${sourced_files[*]} " == *" ${sourced_file} "* ]]; then
          # Add file to sourced list, 
          sourced_files+=("${sourced_file}")

          # Write sourced file contents to output.
          [[ "${debug}" -ne 0 ]] && cecho 'DEBUG' "Debug: including file '${sourced_file}' in output." >&2
          if ! recurse-sources --debug="${debug}" --origin="${source_origin}" \
            --input="${sourced_file}" \
            --output="${output}"; then
            if [[ -z "${origin}" ]]; then
              cecho "ERROR" "Error: failed during assemblage of file '${input}'." >&2
            else
              cecho "ERROR" "Error: failed during assemblage of file '${source_origin}' in '${input}'." >&2
            fi
            return 1
          fi

          cecho 'INFO' "Info: file '${sourced_file}' assembled successfully." >&2
        else
          cecho 'INFO' "Info: file '${sourced_file}' is already assembled." >&2
        fi
      fi
    else
      # Write line as it in output.
      echo -E "${line}" >>"${output}"
    fi

    ((line_count++))
  done < "${input}"

  return 0
}

function assemble-sources() {
  local input="${1}"
  local output="${2}"

  recurse-sources --input="${input}" --output="${output}"

  return
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && assemble-sources "${@}"
