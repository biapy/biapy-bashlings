#!/usr/bin/env bash
# @file src/is-url.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Test if a string is a HTTP, HTTPS, FTP or FILE URL.
# @description
#   is-url test if given string match with a URL validation regex restricted
#   to web protocols (i.e. HTTP, HTTPS, FTP and FILE).

source "${BASH_SOURCE[0]%/*}/cecho.bash"

# @description
#   Test if given string match with a URL validation regex restricted
#   to web protocols (i.e. HTTP, HTTPS and FTP).
#
# @example
#   source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/is-url.bash"
#   if is-url "${url}"; then
#     wget "${url}"
#   else
#     echo "Error: '${url}' is not a valid url." >&2
#     exit 1
#   fi
#
# @arg $1 string A string that may be a valid URL.
#
# @exitcode 0 If string is a valid HTTPS, HTTP, FTP or FILE URL.
# @exitcode 1 If argument is missing or more than one argument given.
# @exitcode 1 If string is not a URL or URL with an invalid protocol.
#
# @stderr Error if the argument is missing or more than one argument is given.
#
# @see [cecho](./cecho.md#cecho)
# @see [Check for valid link (URL) @ Stack Overflow](https://stackoverflow.com/questions/3183444/check-for-valid-link-url)
function is-url() {
  # Accept one and only one argument.
  if [[ ${#} -ne 1 ]]; then
    cecho "ERROR" "Error: ${FUNCNAME[0]} must have one and only one argument." >&2
    return 1
  fi

  local url="${1}"
  local url_regex='^(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]\.?[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'

  [[ "${url}" =~ ${url_regex} ]] && return 0

  return 1
} # is-url()
