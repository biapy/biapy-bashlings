#!/usr/bin/env bash
# @file src/isUrl.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Legacy alias for `is-url` function.
# @description
#     Allow to call `is-url` by using the legacy name `isUrl`.

source "${BASH_SOURCE[0]%/*}/is-url.bash"

# @description
#   Test if given string match with a URL validation regex restricted
#   to web protocols (i.e. HTTP, HTTPS and FTP).
#
# @deprecated
#
# @see [is-url](./is-url.md#is-url)
function isUrl() {
  is-url "${@}"
  return
}
