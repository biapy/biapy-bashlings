#!/usr/bin/env bats
# join-array.bats
# Test join-array.bash:join-array function.

# shellcheck source-path=SCRIPTDIR../src

# Setup test environment.
setup() {
    # Load bats libraries.
    load 'test_helper/common-setup'
    _common_setup

    # Sourcing join-array.bash
    source "${PROJECT_ROOT}/src/join-array.bash"
}

# Teardown test environment.
teardown() {
    _common_teardown
}

# bats file_tags=function:join-array,scope:public

@test "fail with error on missing argument" {
    run join-array
    assert_failure
    assert_output "Error: join-array requires a separator as first argument."
}

@test "allows separator to be empty" {
    run join-array '' 'start' 'end'
    assert_success
    assert_output 'startend'
}

@test "allows array to be empty" {
    run join-array 'separator'
    assert_success
    assert_output ''
}

@test "allows array to contains only one item" {
    run join-array 'separator' 'single'
    assert_success
    assert_output 'single'
}

@test "succeed in joining array contents with string separator" {
    separator=' separ@tor '
    declare -a 'long_array'
    long_array=('first' 2 'third')
    run join-array "${separator}" ${long_array[@]+"${long_array[@]}"}
    assert_success
    assert_output "${long_array[0]-}${separator}${long_array[1]-}${separator}${long_array[2]-}"
}

@test "success in joining an array with line break" {
    run join-array '\n' 'first' 'second'
    assert_success
    assert_line --index 0 "first"
    assert_line --index 1 "second"
}

@test "success in joining array with tab" {
    run join-array '\t' 'first' 'second'
    assert_success
    assert_output "$(echo -ne 'first\tsecond')"
}
