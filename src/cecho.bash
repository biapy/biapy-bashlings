#!/usr/bin/env bash
# @file src/cecho.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Colored Echo: output text in color.
# @description
#   `cecho` is a wrapper around `tput` and `echo` for outputting colored text.

# @description
#   `cecho` is a wrapper around `tput` and `echo` for outputting colored text.
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
# @option -n Do not output the trailing newline
# @option -e Enable interpretation of backslash escapes
# @option -E Disable interpretation of backslash escapes (default)
#
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
  local force
  local tput_options
  declare -a tput_options
  local echo_options
  declare -a echo_options
  echo_options=()
  # Detect if force colored output option is given.
  force=0
  while [[ "${1-}" =~ ^(-f|--force|-n|-e|-E)$ ]]; do
    # -f | --force is a cecho option for forcing color output.
    if [[ "${1-}" = "--force" || "${1-}" = "-f" ]]; then
      force=1
    else
      echo_options+=("${1-}")
    fi

    # Remove echo option from arguments.
    shift
  done

  # If only one argument is given (i.e. no color, call echo as is.)
  if [[ ${#} -lt 2 ]]; then
    echo ${echo_options[@]+"${echo_options[@]}"} ${@+"$@"}
    return
  fi

  # Test if tput is working without issue (e.g. TERM is unset or empty).
  # If tput exit with error, try to fix the issue by using -Tdumb option.
  tput_options=()
  if ! tput 'cols' > '/dev/null' 2>&1; then
    tput_options+=('-Tdumb')
  fi

  local font_index
  local font_value

  declare -a font_index
  declare -a font_value

  font_index=()
  font_value=()

  font_index+=('black')
  font_value+=('setaf 0')
  font_index+=('red')
  font_value+=('setaf 1')
  font_index+=('green')
  font_value+=('setaf 2')
  font_index+=('yellow')
  font_value+=('setaf 3')
  font_index+=('blue')
  font_value+=('setaf 4')
  font_index+=('magenta')
  font_value+=('setaf 5')
  font_index+=('cyan')
  font_value+=('setaf 6')
  font_index+=('white')
  font_value+=('setaf 7')

  font_index+=('bgBlack')
  font_value+=('setab 0')
  font_index+=('bgRed')
  font_value+=('setab 1')
  font_index+=('bgGreen')
  font_value+=('setab 2')
  font_index+=('bgYellow')
  font_value+=('setab 3')
  font_index+=('bgBlue')
  font_value+=('setab 4')
  font_index+=('bgMagenta')
  font_value+=('setab 5')
  font_index+=('bgCyan')
  font_value+=('setab 6')
  font_index+=('bgWhite')
  font_value+=('setab 7')

  font_index+=('bold')
  font_value+=('bold')
  font_index+=('stout')
  font_value+=('smso') # Standout.
  font_index+=('under')
  font_value+=('smul') # Underline.
  font_index+=('blink')
  font_value+=('blink') # Blinking.
  font_index+=('reverse')
  font_value+=('rev') # Exchange foreground & background colors.
  font_index+=('italic')
  font_value+=('sitm')

  local color="${1-}"
  local key
  local color_found=0
  local color_name
  local color_codes=''
  # For each valid color name.

  # Replace special "colors" by the equivalent codes.
  color="${color//INFO/bluebold}"
  color="${color//WARNING/yellowbold}"
  color="${color//ERROR/redbold}"
  color="${color//SUCCESS/greenbold}"
  color="${color//DEBUG/italic}"

  # For each color in color index,
  for key in "${!font_index[@]}"; do
    color_name="${font_index[${key}]-}"

    # If color name found in ${color}.
    if [[ "${color-}" = *"${color_name-}"* ]]; then
      # Set flag signaling that valid color has been found.
      color_found=1

      # Add color code to output.

      color_codes="${color_codes-}$(
        # shellcheck disable=SC2086 # font_value value needs to be splitted.
        tput ${tput_options[@]+"${tput_options[@]}"} ${font_value[${key}]-} || true
      )"

      # Remove color name from ${color}
      color="${color//${color_name}/}"
    fi
  done

  # If color codes provided,
  if [[ "${color_found-}" -ne 0 ]]; then
    # Check that only color codes where given (ie no unknown code)
    if [[ ! "${color-}" =~ ^[[:space:]]*$ ]]; then
      cecho "ERROR" "Error: '${color}' is not a valid color code." >&2
      return 1
    fi

    # remove valid color information from arguments.
    shift 1
  fi

  # Check that the output is to a terminal,
  # and force color output is not triggered.
  if [[ ! -t 1 && "${force-0}" -eq 0 ]]; then
    # Not outputing to a terminal, discarding colors.
    echo ${echo_options[@]+"${echo_options[@]}"} ${@+"$@"}
    return
  fi

  # Output the text and reset all color attributes.
  echo ${echo_options[@]+"${echo_options[@]}"} \
    "${color_codes-}${*}$(
      tput ${tput_options[@]+"${tput_options[@]}"} 'sgr0' || true
    )"
  return
}
