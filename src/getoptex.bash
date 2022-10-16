#!/usr/bin/env bash

# Include from /usr/share/doc/bash-doc/examples/functions/getoptx.bash
# of package bash-doc.
# Variables have been renamed for better lisibility and comprehension.
function getoptex() {
  (($#)) || return 1
  local optionList
  optionList="${1#;}"
  ((optionIndex)) || optionIndex=1
  [[ "${optionIndex}" -lt "${#}" ]] || return 1
  shift "${optionIndex}"
  if [[ "${1}" != "-" && "${1}" != "${1#-}" ]]; then
    optionIndex=$((optionIndex + 1))
    if [[ "${1}" != "--" ]]; then
      local o
      o="-${1#-"${optionOfs}"}"
      for opt in ${optionList#;}; do
        optionName="${opt%[;.:]}"
        unset optionArgument
        local optionType="${opt##*[^;:.]}"
        [[ -z "${optionType}" ]] && optionType=";"
        if [[ ${#optionName} -gt 1 ]]; then
          # long-named option
          case "${o}" in
          "--${optionName}")
            if [[ "${optionType}" != ":" ]]; then
              return 0
            fi
            optionArgument="$2"
            if [[ -z "${optionArgument}" ]]; then
              # error: must have an agrument
              echo "$0: error: ${optionName} must have an argument" >&2
              optionArgument="${optionName}"
              optionName="?"
              return 1
            fi
            optionIndex=$((optionIndex + 1)) # skip option's argument
            return 0
            ;;
          "--${optionName}="*)
            if [[ "${optionType}" = ";" ]]; then # error: must not have arguments
              ((OPTERR)) && echo "$0: error: ${optionName} must not have arguments" >&2
              optionArgument="${optionName}"
              optionName="?"
              return 1
            fi
            optionArgument="${o#--"${optionName}"=}"
            return 0
            ;;
          * )
            # Ignore other values.
            ;;
          esac
        else # short-named option
          case "${o}" in
          "-${optionName}")
            unset optionOfs
            [[ "${optionType}" != ":" ]] && return 0
            optionArgument="$2"
            if [[ -z "${optionArgument}" ]]; then
              echo "$0: error: -${optionName} must have an argument" >&2
              optionArgument="${optionName}"
              optionName="?"
              return 1
            fi
            optionIndex=$((optionIndex + 1)) # skip option's argument
            return 0
            ;;
          "-${optionName}"*)
            if [[ ${optionType} = ";" ]]; then   # an option with no argument is in a chain of options
              optionOfs="${optionOfs}?"        # move to the next option in the chain
              optionIndex=$((optionIndex - 1)) # the chain still has other options
              return 0
            else
              unset optionOfs
              optionArgument="${o#-"${optionName}"}"
              return 0
            fi
            ;;
          * )
            # Ignore other values.
            ;;
          esac
        fi
      done
      echo "Error : invalid option : '${o}'." >&2
      usage 1
    fi
  fi
  optionName="?"
  unset optionArgument
  return 1
}

function optionListex {
  local l="${1}"
  local m                                                # mask
  local r                                                # to store result
  while [[ ${#m} -lt $((${#l} - 1)) ]]; do m="${m}?"; done # create a "???..." mask
  while [[ -n "${l}" ]]; do
    r="${r:+"${r} "}${l%"${m}"}"          # append the first character of $l to $r
    l="${l#?}"                        # cut the first charecter from $l
    m="${m#?}"                        # cut one "?" sign from m
    if [[ -n "${l%%[^:.;]*}" ]]; then # a special character (";", ".", or ":") was found
      r="${r}${l%"${m}"}"                 # append it to $r
      l="${l#?}"                      # cut the special character from l
      m="${m#?}"                      # cut one more "?" sign
    fi
  done
  echo "${r}"
}

function getopt() {
  local optionList

  optionList="$(optionListex "${1}")"
  shift
  getoptex "${optionList}" "${@}"
  return ${?}
}
