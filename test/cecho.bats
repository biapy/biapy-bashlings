#!/usr/bin/env ./test/bats/bin/bats
# cecho.bats
# Test cecho.bash:cecho function.

# Setup test environment.
setup() {
    # Load bats libraries.
    load 'test_helper/common-setup'
    _common_setup

    # Sourcing cecho.bash
    source "${PROJECT_ROOT}/src/cecho.bash"
}

# Teardown test environment.
teardown() {
    _common_teardown
}

# bats file_tags=function:cecho

@test "output standard input" {
    run cecho "output"
    assert_success
    assert_output "output"
}

@test "output multiple input" {
    run cecho "output" "other-output"
    assert_success
    assert_output "output other-output"
}

@test "output colored input" {
    run cecho 'black' "output"
    assert_success
    assert_output "output"
}



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