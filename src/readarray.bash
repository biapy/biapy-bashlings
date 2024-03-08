#!/usr/bin/env bash
# @file src/readarray.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief pure bash implementation of the mapfile command.
# @description
#   `readarray` is a pure bash implementation of the `mapfile` command for
#   systems with bash < 4.0, namely MacOS.

# @description
#   Read lines from a file or stream into an array.
#
# @example
#   source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/readarray.bash"
#   readarray 'my_array' < <(echo -e "line1\nline2\nline3")
#
# @option -d <delim>  Use DELIM to terminate lines, instead of newline
# @option -n <count>  Copy at most COUNT lines.  If COUNT is 0, all lines are copied
# @option -O <origin> Begin assigning to ARRAY at index ORIGIN.  The default index is 0
# @option -s <count>  Discard the first COUNT lines read
# @option -t <        Remove a trailing DELIM from each line read (default newline)
# @option -u <fd>     Read lines from file descriptor FD instead of the standard input
# @option -C <callback> Evaluate CALLBACK each time QUANTUM lines are read
# @option -c <quantum>  Specify the number of lines read between each call to
CALLBACK
# @arg $1 Array variable name to use for file data
#
# @exitcode 0 If email is successfully sent.
# @exitcode 1 If argument is missing.
#
# @stderr Error if the argument is missing or more than one argument is given.
#
# @see [2.1. Loading lines from a file or stream @ Bash FAQ](https://mywiki.wooledge.org/BashFAQ/005#Loading_lines_from_a_file_or_stream)
# @see [alternative to readarray, because it does not work on mac os x @ Stack Overflow](https://stackoverflow.com/questions/23842261/alternative-to-readarray-because-it-does-not-work-on-mac-os-x)
readarray() {
  # TODO: Implement options
  local __resultvar="${1}"
  declare -a __local_array
  local i=0
  while IFS=$'\n' read -r line_data; do
    __local_array[i]=${line_data}
    ((++i))
  done <"${2}"
  if [[ "${__resultvar}" ]]; then
    eval "${__resultvar}='${__local_array[*]}'"
  else
    echo "${__local_array[@]}"
  fi
}
