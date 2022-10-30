#!/bin/bash
#!/usr/bin/env bash
# @file in-list.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Test if a value is in a list.
# @description
#   in-list test if given string is found in a list.

source "${BASH_SOURCE[0]%/*}/cecho.bash"

# @description
#   Test if given string is found in the remaining arguments.
#
# @example
#   source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/in-list.bash"
#   value='te(x|s)t'
#   example_list=( 'test' 'second text' 10 11 )
#   if in-list "${value}" "${example_list[@]}" then
#     echo "Found."
#   else
#     echo "Error: Not found." >&2
#     exit 1
#   fi
#
# @arg $1 string The searched string, allow for regex syntax (excluding ^ and $).
# @arg $@ any The contents of the list in which the string is searched.
#
# @stderr Display an error if string is missing.
#
# @exitcode 0 If string is found in list.
# @exitcode 1 If string is not found in list, or string is missing.
#
# @see cecho
function in-list() {
  # Must have at least one argument.
  if [[ ${#} -eq 0 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} must have at least one argument." >&2
    return 1
  fi

  local search="${1}"
  local list=( "${@:2}" )

  local search_regexp="^.*[!]${search}[!].*\$"
  local searched_list

  # build searched list with custom separator.
  IFS='!' searched_list="!${list[*]}!"
  
  # Check is search is exactly matched in list.
  if [[ "${searched_list}" =~ ${search_regexp} ]]; then
    # Found the 
    return 0
  fi

  return 1
} # in-list()