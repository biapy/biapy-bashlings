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

@test "Output lone color code" {
    run cecho 'red'
    assert_success
    assert_output "red"
}

@test "fail on unknown color code" {
    run cecho 'blackunknownbold' "output"
    assert_failure
    assert_output "Error: 'unknown' is not a valid color code."
}

@test "output input without color in pipe" {
    run cecho 'black' "output"
    assert_success
    assert_output "output"
}

@test "Force output with color in pipe (-f)" {
    run cecho -f 'black' "output"
    assert_success
    assert_output "$( tput 'setaf' 0 || true )output$( tput 'sgr0' || true )"
}

@test "Force output with color in pipe (--force)" {
    run cecho --force 'black' "output"
    assert_success
    assert_output "$( tput 'setaf' 0 || true )output$( tput 'sgr0' || true )"
}

@test "Check black color" {
    run cecho --force 'black' "output"
    assert_success
    assert_output "$( tput 'setaf' 0 || true )output$( tput 'sgr0' || true )"
}

@test "Check red color" {
    run cecho --force 'red' "output"
    assert_success
    assert_output "$( tput 'setaf' 1 || true )output$( tput 'sgr0' || true )"
}

@test "Check green color" {
    run cecho --force 'green' "output"
    assert_success
    assert_output "$( tput 'setaf' 2 || true )output$( tput 'sgr0' || true )"
}

@test "Check yellow color" {
    run cecho --force 'yellow' "output"
    assert_success
    assert_output "$( tput 'setaf' 3 || true )output$( tput 'sgr0' || true )"
}

@test "Check blue color" {
    run cecho --force 'blue' "output"
    assert_success
    assert_output "$( tput 'setaf' 4 || true )output$( tput 'sgr0' || true )"
}

@test "Check magenta color" {
    run cecho --force 'magenta' "output"
    assert_success
    assert_output "$( tput 'setaf' 5 || true )output$( tput 'sgr0' || true )"
}

@test "Check cyan color" {
    run cecho --force 'cyan' "output"
    assert_success
    assert_output "$( tput 'setaf' 6 || true )output$( tput 'sgr0' || true )"
}

@test "Check white color" {
    run cecho --force 'white' "output"
    assert_success
    assert_output "$( tput 'setaf' 7 || true )output$( tput 'sgr0' || true )"
}

@test "Check bgBlack color" {
    run cecho --force 'bgBlack' "output"
    assert_success
    assert_output "$( tput 'setab' 0 || true )output$( tput 'sgr0' || true )"
}

@test "Check bgRed color" {
    run cecho --force 'bgRed' "output"
    assert_success
    assert_output "$( tput 'setab' 1 || true )output$( tput 'sgr0' || true )"
}

@test "Check bgGreen color" {
    run cecho --force 'bgGreen' "output"
    assert_success
    assert_output "$( tput 'setab' 2 || true )output$( tput 'sgr0' || true )"
}

@test "Check bgYellow color" {
    run cecho --force 'bgYellow' "output"
    assert_success
    assert_output "$( tput 'setab' 3 || true )output$( tput 'sgr0' || true )"
}

@test "Check bgBlue color" {
    run cecho --force 'bgBlue' "output"
    assert_success
    assert_output "$( tput 'setab' 4 || true )output$( tput 'sgr0' || true )"
}

@test "Check bgMagenta color" {
    run cecho --force 'bgMagenta' "output"
    assert_success
    assert_output "$( tput 'setab' 5 || true )output$( tput 'sgr0' || true )"
}

@test "Check bgCyan color" {
    run cecho --force 'bgCyan' "output"
    assert_success
    assert_output "$( tput 'setab' 6 || true )output$( tput 'sgr0' || true )"
}

@test "Check bgWhite color" {
    run cecho --force 'bgWhite' "output"
    assert_success
    assert_output "$( tput 'setab' 7 || true )output$( tput 'sgr0' || true )"
}

@test "Check bold style" {
    run cecho --force 'bold' "output"
    assert_success
    assert_output "$( tput 'bold' || true )output$( tput 'sgr0' || true )"
}

@test "Check stout (standout) style" {
    run cecho --force 'stout' "output"
    assert_success
    assert_output "$( tput 'smso' || true )output$( tput 'sgr0' || true )"
}

@test "Check under (underline) style" {
    run cecho --force 'under' "output"
    assert_success
    assert_output "$( tput 'smul' || true )output$( tput 'sgr0' || true )"
}

@test "Check blink style" {
    run cecho --force 'blink' "output"
    assert_success
    assert_output "$( tput 'blink' || true )output$( tput 'sgr0' || true )"
}

@test "Check reverse style" {
    run cecho --force 'reverse' "output"
    assert_success
    assert_output "$( tput 'rev' || true )output$( tput 'sgr0' || true )"
}

@test "Check italic style" {
    run cecho --force 'italic' "output"
    assert_success
    assert_output "$( tput 'sitm' || true )output$( tput 'sgr0' || true )"
}

@test "Check composite (red bold) style" {
    run cecho --force 'red bold' "output"
    assert_success
    assert_output "$( tput 'setaf' 1 || true )$( tput 'bold' || true )output$( tput 'sgr0' || true )"
}

@test "Check INFO style" {
    run cecho --force 'INFO' "output"
    assert_success
    assert_output "$( tput 'setaf' 4 || true )$( tput 'bold' || true )output$( tput 'sgr0' || true )"
}

@test "Check WARNING style" {
    run cecho --force 'WARNING' "output"
    assert_success
    assert_output "$( tput 'setaf' 3 || true )$( tput 'bold' || true )output$( tput 'sgr0' || true )"
}

@test "Check ERROR style" {
    run cecho --force 'ERROR' "output"
    assert_success
    assert_output "$( tput 'setaf' 1 || true )$( tput 'bold' || true )output$( tput 'sgr0' || true )"
}

@test "Check SUCCESS style" {
    run cecho --force 'SUCCESS' "output"
    assert_success
    assert_output "$( tput 'setaf' 2 || true )$( tput 'bold' || true )output$( tput 'sgr0' || true )"
}

@test "Check DEBUG style" {
    run cecho --force 'DEBUG' "output"
    assert_success
    assert_output "$( tput 'sitm' || true )output$( tput 'sgr0' || true )"
}
