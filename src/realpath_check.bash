#!/usr/bin/env bash

source 'realpath.bash'
source 'getoptex.bash'
source 'cecho.bash'

# Get the absolute path for a file or directory and check the file existance.
# If the file does not exists, display an error message and exit the script.
# Print its path on &1 if found.
#
# @param string $quiet A optionnal '--quiet' tag to disable the error message.
# @param string $exit A optionnal '--exit' tag to enable exit on failure.
# @param string $path A relative path.
#
# @return 1 if the path does not exist, 0 otherwise.
function realpath_check() {
  [[ ${#} -ge 1 && ${#} -le 3 ]] || exit 1

  local optionIndex
  local optionName
  # Options debuging.
  # local optionArgument

  local quiet=0
  local exitOnError=0
  local path=''
  local realpath=''

  # Parse options using getoptex from /usr/share/doc/bash-doc/examples/functions/getoptx.bash
  while getoptex "exit e quiet q" "${@}"; do
    # Options debuging.
    # echo "Option <$optionName> ${optionArgument:+has an arg <$optionArgument>}"

    case "${optionName}" in
    'quiet' | 'q')
      quiet=1
      ;;

    'exit' | 'e')
      exitOnError=1
      ;;

    * )
      # Discard other options.
      ;;
    esac
  done

  # Discard processed options.
  shift $((optionIndex - 1))

  path="${1}"

  realpath="$(realpath "${path}")"

  if [[ -n "${realpath}" && ! -e "${realpath}" ]]; then
    realpath=''
  fi

  if [[ -z "${realpath}" ]]; then
    [[ "${quiet}" -eq 0 ]] && cecho 'redbold' "Error: File '${path}' does not exists." >&2
    [[ "${exitOnError}" -ne 0 ]] && exit 1
    return 1
  fi

  echo -n "${realpath}"
  return 0
} # realpath_check