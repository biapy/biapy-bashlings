#!/usr/bin/env bash

# Echo text in color.
#
# Colors definitions.
# See http://mywiki.wooledge.org/BashFAQ/037
#
# @param string $color Color and weight for text. (boldgreen for example).
# @param string $text The text to echo (and echo options).
function cecho() {
  if [[ ${#} -lt 2 ]]; then
    echo "${@}"
    return
  fi

  # Bash 4 version with associative array.
  ## Color and weight definitions.
  #declare -A font
  #font['black']="$(tput 'setaf' 0)"
  #font['red']="$(tput 'setaf' 1)"
  #font['green']="$(tput 'setaf' 2)"
  #font['yellow']="$(tput 'setaf' 3)"
  #font['blue']="$(tput 'setaf' 4)"
  #font['magenta']="$(tput 'setaf' 5)"
  #font['cyan']="$(tput 'setaf' 6)"
  #font['white']="$(tput 'setaf' 7)"

  #font['bgBlack']="$(tput 'setab' 0)"
  #font['bgRed']="$(tput 'setab' 1)"
  #font['bgGreen']="$(tput 'setab' 2)"
  #font['bgYellow']="$(tput 'setab' 3)"
  #font['bgBlue']="$(tput 'setab' 4)"
  #font['bgMagenta']="$(tput 'setab' 5)"
  #font['bgCyan']="$(tput 'setab' 6)"
  #font['bgWhite']="$(tput 'setab' 7)"

  #font['bold']="$(tput 'bold')"
  #font['stout']="$(tput 'smso')" # Standout.
  #font['under']="$(tput 'smul')" # Underline.
  #font['blink']="$(tput 'blink')" # Blinking
  #font['italic']="$(tput 'sitm')"

  ## Parse the color string.
  #for key in "${!font[@]}"; do
  #  [[ "${color}" = *"${key}"* ]] && echo -n "${font[${key}]}"
  #done

  declare -a font_index
  declare -a font_value

  font_index=()
  font_value=()

  font_index+=('black')
  font_value+=("$(tput 'setaf' 0)")
  font_index+=('red')
  font_value+=("$(tput 'setaf' 1)")
  font_index+=('green')
  font_value+=("$(tput 'setaf' 2)")
  font_index+=('yellow')
  font_value+=("$(tput 'setaf' 3)")
  font_index+=('blue')
  font_value+=("$(tput 'setaf' 4)")
  font_index+=('magenta')
  font_value+=("$(tput 'setaf' 5)")
  font_index+=('cyan')
  font_value+=("$(tput 'setaf' 6)")
  font_index+=('white')
  font_value+=("$(tput 'setaf' 7)")

  font_index+=('bgBlack')
  font_value+=("$(tput 'setab' 0)")
  font_index+=('bgRed')
  font_value+=("$(tput 'setab' 1)")
  font_index+=('bgGreen')
  font_value+=("$(tput 'setab' 2)")
  font_index+=('bgYellow')
  font_value+=("$(tput 'setab' 3)")
  font_index+=('bgBlue')
  font_value+=("$(tput 'setab' 4)")
  font_index+=('bgMagenta')
  font_value+=("$(tput 'setab' 5)")
  font_index+=('bgCyan')
  font_value+=("$(tput 'setab' 6)")
  font_index+=('bgWhite')
  font_value+=("$(tput 'setab' 7)")

  font_index+=('bold')
  font_value+=("$(tput 'bold')")
  font_index+=('stout')
  font_value+=("$(tput 'smso')") # Standout.
  font_index+=('under')
  font_value+=("$(tput 'smul')") # Underline.
  font_index+=('blink')
  font_value+=("$(tput 'blink')") # Blinking.
  font_index+=('italic')
  font_value+=("$(tput 'sitm')")

  # Special complex values
  # INFO : bluebold
  font_index+=('INFO')
  # shellcheck disable=SC2312
  font_value+=("$(tput 'setaf' 4)$(tput 'bold')")
  # WARNING : yellowbold
  font_index+=('WARNING')
  # shellcheck disable=SC2312
  font_value+=("$(tput 'setaf' 3)$(tput 'bold')")
  # ERROR : redbold
  font_index+=('ERROR')
  # shellcheck disable=SC2312
  font_value+=("$(tput 'setaf' 1)$(tput 'bold')")
  # SUCCESS : greenbold
  font_index+=('SUCCESS')
  # shellcheck disable=SC2312
  font_value+=("$(tput 'setaf' 2)$(tput 'bold')")
  # DEBUG : italic
  font_index+=('DEBUG')
  # shellcheck disable=SC2312
  font_value+=("$(tput 'sitm')")

  local color="${1}"
  local key
  local color_codes=""

  for key in "${!font_index[@]}"; do
    [[ "${color}" = *"${font_index[${key}]}"* ]] &&
      color_codes="${color_codes}${font_value[${key}]}"
  done

  # remove valid color information from arguments.
  [[ -n "${color_codes}" ]] && shift 1

  # Check that the output is to a terminal.
  if [[ ! -t 1 ]]; then
    # Not outputing to a terminal, discarding colors.
    echo "${@}"
    return
  fi

  # Output the text and reset all color attributes.
  echo "${color_codes}${*}$(tput 'sgr0' || true)"
  return
} # cecho()
