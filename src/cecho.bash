#!/usr/bin/env bash
# @file src/cecho.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Colored Echo: output text in color.
# @description
#   `cecho` in a wrapper around `tput` and `echo` for outputting colored text.

# @description
#   `cecho` in a wrapper around `tput` and `echo` for outputting colored text.
#
#   `cecho` support one of these text color modifiers:
#
#   * 'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white'
#
#   `cecho` support one of these background color modifiers:
#
#   * 'bgBlack', 'bgRed', 'bgGreen', 'bgYellow', 'bgBlue', 'bgMagenta', 'bgCyan', 'bgWhite'
#
#   `cecho` support one or more of these styles modifiers:
#
#   * 'bold', 'stout', 'under', 'blink', 'reverse', 'italic'
#
#   `cecho` provides theses custom styles:
#
#   * 'INFO', 'WARNING', 'ERROR', 'SUCCESS', 'DEBUG'
#
# @example
#   source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/cecho.bash"
#   cecho "red bold reverse" "A reversed red bold text"
#   cecho "INFO" "Info: there is news !"
#   cecho "ERROR" "Error: the news is false !"
#   cecho "DEBUG" "Debug: \$news is set by a waring party."
#
# @option -f | --force Force colored output to pipe. Allow to print colored output in files.
# @arg $1 string (optional) The output color style ( color + background color + styles).
# @arg $@ string The outputted contents.
#
# @exitcode 0 If the text is outputted successfully.
# @exitcode 1 If $1 contains an unsupported color code.
#
# @stdout A colored (or not) text. If stdout is a pipe, the coloring is disabled unless `--force`` is used.
# @stderr Error if $1 contains an unsupported code.
#
# @see [How can I print text in various colors? @ BashFAQ](http://mywiki.wooledge.org/BashFAQ/037)
function cecho() {
  # Detect if force colored output option is given.
  force=0
  if [[ "${1}" = "--force" || "${1}" = "-f" ]]; then
    force=1
    shift
  fi

  if [[ ${#} -lt 2 ]]; then
    echo "${@}"
    return
  fi

  # Test if tput is working without issue (e.g. TERM is unset or empty).
  # If tput exit with error, try to fix the issue by using -Tdumb option.
  local tput_options=()
  if ! tput 'cols' > '/dev/null' 2>&1; then
    tput_options=('-Tdumb')
  fi

  # Bash 4 version with associative array.
  ## Color and weight definitions.
  #declare -A font
  #font['black']="$(tput "${tput_options[@]}" 'setaf' 0)"
  #font['red']="$(tput "${tput_options[@]}" 'setaf' 1)"
  #font['green']="$(tput "${tput_options[@]}" 'setaf' 2)"
  #font['yellow']="$(tput "${tput_options[@]}" 'setaf' 3)"
  #font['blue']="$(tput "${tput_options[@]}" 'setaf' 4)"
  #font['magenta']="$(tput "${tput_options[@]}" 'setaf' 5)"
  #font['cyan']="$(tput "${tput_options[@]}" 'setaf' 6)"
  #font['white']="$(tput "${tput_options[@]}" 'setaf' 7)"

  #font['bgBlack']="$(tput "${tput_options[@]}" 'setab' 0)"
  #font['bgRed']="$(tput "${tput_options[@]}" 'setab' 1)"
  #font['bgGreen']="$(tput "${tput_options[@]}" 'setab' 2)"
  #font['bgYellow']="$(tput "${tput_options[@]}" 'setab' 3)"
  #font['bgBlue']="$(tput "${tput_options[@]}" 'setab' 4)"
  #font['bgMagenta']="$(tput "${tput_options[@]}" 'setab' 5)"
  #font['bgCyan']="$(tput "${tput_options[@]}" 'setab' 6)"
  #font['bgWhite']="$(tput "${tput_options[@]}" 'setab' 7)"

  #font['bold']="$(tput "${tput_options[@]}" 'bold')"
  #font['stout']="$(tput "${tput_options[@]}" 'smso')" # Standout.
  #font['under']="$(tput "${tput_options[@]}" 'smul')" # Underline.
  #font['blink']="$(tput "${tput_options[@]}" 'blink')" # Blinking
  #font['reverse']="$(tput "${tput_options[@]}" 'rev')" # Reverse background and text colors.
  #font['italic']="$(tput "${tput_options[@]}" 'sitm')"

  ## Parse the color string.
  #for key in "${!font[@]}"; do
  #  [[ "${color}" = *"${key}"* ]] && echo -n "${font[${key}]}"
  #done

  local font_index
  local font_value

  declare -a font_index
  declare -a font_value

  font_index=()
  font_value=()

  font_index+=('black')
  font_value+=("$(tput "${tput_options[@]}" 'setaf' 0)")
  font_index+=('red')
  font_value+=("$(tput "${tput_options[@]}" 'setaf' 1)")
  font_index+=('green')
  font_value+=("$(tput "${tput_options[@]}" 'setaf' 2)")
  font_index+=('yellow')
  font_value+=("$(tput "${tput_options[@]}" 'setaf' 3)")
  font_index+=('blue')
  font_value+=("$(tput "${tput_options[@]}" 'setaf' 4)")
  font_index+=('magenta')
  font_value+=("$(tput "${tput_options[@]}" 'setaf' 5)")
  font_index+=('cyan')
  font_value+=("$(tput "${tput_options[@]}" 'setaf' 6)")
  font_index+=('white')
  font_value+=("$(tput "${tput_options[@]}" 'setaf' 7)")

  font_index+=('bgBlack')
  font_value+=("$(tput "${tput_options[@]}" 'setab' 0)")
  font_index+=('bgRed')
  font_value+=("$(tput "${tput_options[@]}" 'setab' 1)")
  font_index+=('bgGreen')
  font_value+=("$(tput "${tput_options[@]}" 'setab' 2)")
  font_index+=('bgYellow')
  font_value+=("$(tput "${tput_options[@]}" 'setab' 3)")
  font_index+=('bgBlue')
  font_value+=("$(tput "${tput_options[@]}" 'setab' 4)")
  font_index+=('bgMagenta')
  font_value+=("$(tput "${tput_options[@]}" 'setab' 5)")
  font_index+=('bgCyan')
  font_value+=("$(tput "${tput_options[@]}" 'setab' 6)")
  font_index+=('bgWhite')
  font_value+=("$(tput "${tput_options[@]}" 'setab' 7)")

  font_index+=('bold')
  font_value+=("$(tput "${tput_options[@]}" 'bold')")
  font_index+=('stout')
  font_value+=("$(tput "${tput_options[@]}" 'smso')") # Standout.
  font_index+=('under')
  font_value+=("$(tput "${tput_options[@]}" 'smul')") # Underline.
  font_index+=('blink')
  font_value+=("$(tput "${tput_options[@]}" 'blink')") # Blinking.
  font_index+=('reverse')
  font_value+=("$(tput "${tput_options[@]}" 'rev')") # Blinking.
  font_index+=('italic')
  font_value+=("$(tput "${tput_options[@]}" 'sitm')")

  # Special complex values
  # INFO : bluebold
  font_index+=('INFO')
  # shellcheck disable=SC2312
  font_value+=("$(tput "${tput_options[@]}" 'setaf' 4)$(tput "${tput_options[@]}" 'bold')")
  # WARNING : yellowbold
  font_index+=('WARNING')
  # shellcheck disable=SC2312
  font_value+=("$(tput "${tput_options[@]}" 'setaf' 3)$(tput "${tput_options[@]}" 'bold')")
  # ERROR : redbold
  font_index+=('ERROR')
  # shellcheck disable=SC2312
  font_value+=("$(tput "${tput_options[@]}" 'setaf' 1)$(tput "${tput_options[@]}" 'bold')")
  # SUCCESS : greenbold
  font_index+=('SUCCESS')
  # shellcheck disable=SC2312
  font_value+=("$(tput "${tput_options[@]}" 'setaf' 2)$(tput "${tput_options[@]}" 'bold')")
  # DEBUG : italic
  font_index+=('DEBUG')
  font_value+=("$(tput "${tput_options[@]}" 'sitm')")

  local color="${1}"
  local key
  local color_found=0
  local color_codes=""
  local color_name

  # For each valid color name.
  for key in "${!font_index[@]}"; do
    color_name="${font_index[${key}]}"

    # If color name found in ${color}.
    if [[ "${color}" = *"${color_name}"* ]]; then
      # Set flag signaling that valid color has been found.
      color_found=1

      # Add color code to output.
      color_codes="${color_codes}${font_value[${key}]}"

      # Remove color name from ${color}
      color="${color//${color_name}/}"
    fi
  done

  # If color codes provided,
  if [[ "${color_found}" -ne 0 ]]; then
    # Check that only color codes where given (ie no unknown code)
    if [[ ! "${color}" =~ ^[[:space:]]*$ ]]; then
      cecho "ERROR" "Error: '${color}' is not a valid color code." >&2
      return 1
    fi

    # remove valid color information from arguments.
    shift 1
  fi

  # Check that the output is to a terminal,
  # and force color output is not triggered.
  if [[ ! -t 1 && "${force}" -eq 0 ]]; then
    # Not outputing to a terminal, discarding colors.
    echo "${@}"
    return
  fi

  # Output the text and reset all color attributes.
  echo -n "${color_codes}${*}$(tput "${tput_options[@]}" 'sgr0' || true)"
  return
} # cecho()
