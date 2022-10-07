#!/usr/bin/env ./test/libs/bats/bin/bats
# basename.bats
# Test basename.bash:basename function.

# Load bats libraries.
load 'libs/bats-support/load'
load 'libs/bats-assert/load'

@test "Get basename from complete path" {
    source ./src/basename/basename.bash
    run basename "/path/to/file"
    assert_success
    assert_output "file"
}

@test "Get basename from relative path" {
    source ./src/basename/basename.bash
    run basename "../to/file"
    assert_success
    assert_output "file"
}

@test "Get basename from filename" {
    source ./src/basename/basename.bash
    run basename "file"
    assert_success
    assert_output "file"
}

@test "Error on missing argument" {
    source ./src/basename/basename.bash
    run basename
    assert_failure
}

@test "Error on empty argument" {
    source ./src/basename/basename.bash
    run basename ""
    assert_failure
}

@test "Error on more than one argument" {
    source ./src/basename/basename.bash
    run basename "/path/to/file" "/path/to/other-file"
    assert_failure
}