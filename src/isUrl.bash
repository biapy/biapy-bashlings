#!/usr/bin/env bash

# Test if given string is a url.
# @see https://stackoverflow.com/questions/3183444/check-for-valid-link-url
#
# @param string $url The tested URL.
# @return 0 if $url is a URL, 1 otherwise.
function isUrl() {
  local url="${1}"
  local urlRegex='^(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]\.[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'

  [[ "${url}" =~ ${urlRegex} ]] && return 0

  return 1
} # isUrl()