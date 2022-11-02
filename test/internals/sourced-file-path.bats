#!/usr/bin/env ./test/bats/bin/bats
# test/internals/sourced-file-path.bats
# Test src/internals/sourced-file-path.bash:sourced-file-path function.

# Setup test environment.
setup() {
    # Load bats libraries.
    load '../test_helper/common-setup'
    _common_setup

    # Sourcing process-options.bash
    source "${PROJECT_ROOT}/src/internals/sourced-file-path.bash"
}

# Teardown test environment.
teardown() {
    _common_teardown
}

# bats file_tags=function:process-options,scope:private

@test "fail on no arguments" {
    run sourced-file-path
    assert_failure
    assert_output "Error: sourced-file-path must have one and only one argument."
}

@test "fail on 2 arguments" {
    run sourced-file-path 1 2
    assert_failure
    assert_output "Error: sourced-file-path must have one and only one argument."
}

@test "fail on invalid option" {
    run sourced-file-path --test-option
    assert_failure
    assert_output "Error: option '--test-option' is not recognised."
}

@test "fail on random command line" {
    run sourced-file-path 'echo "/path/to/file.bash"'
    assert_failure
    assert_output "Error: unable to extract file from command 'echo \"/path/to/file.bash\"'."
}

@test "fail on commented source command." {
    run sourced-file-path '# source "some/random/file.bash"'
    assert_failure
    assert_output "Error: unable to extract file from command '# source \"some/random/file.bash\"'."
}

@test "fail on commented dot command." {
    run sourced-file-path '  #  . some/random/file.bash'
    assert_failure
    assert_output "Error: unable to extract file from command '  #  . some/random/file.bash'."
}

@test "success on source command of missing file without origin specified." {
    run sourced-file-path 'source "some/random/file.bash"'
    assert_success
    assert_output "some/random/file.bash"
}

@test "success on dot command of missing file without origin specified." {
    run sourced-file-path '    . some/random/file.bash'
    assert_success
    assert_output "some/random/file.bash"
}

@test "fail on source command of missing relative path file with origin specified." {
    run sourced-file-path --origin="${PROJECT_ROOT}/src/realpath_check.bash" 'source "some/random/file.bash"'
    assert_failure
    assert_output "Error: sourced file 'some/random/file.bash' does not exists."
}

@test "fail on dot command of missing relative path file with origin specified." {
    run sourced-file-path --origin="${PROJECT_ROOT}/src/realpath_check.bash"  '. some/random/file.bash'
    assert_failure
    assert_output "Error: sourced file 'some/random/file.bash' does not exists."
}

@test "success on source command of relative path file with origin specified." {
    source "${PROJECT_ROOT}/src/realpath.bash"
    run sourced-file-path --origin="${PROJECT_ROOT}/src/realpath_check.bash" 'source "cecho.bash"'
    assert_success
    assert_output "$( realpath "${PROJECT_ROOT}/src/cecho.bash" )"
}

@test "success on dot command of relative path file with origin specified." {
    source "${PROJECT_ROOT}/src/realpath.bash"
    run sourced-file-path --origin="${PROJECT_ROOT}/src/realpath_check.bash"  '. cecho.bash'
    assert_success
    assert_output "$( realpath "${PROJECT_ROOT}/src/cecho.bash" )"
}

@test "success on source command of BASH_SOURCE path with origin specified." {
    source "${PROJECT_ROOT}/src/realpath.bash"
    run sourced-file-path --origin="${PROJECT_ROOT}/src/realpath_check.bash" 'source "${BASH_SOURCE[0]%/*}/cecho.bash"'
    assert_success
    assert_output "$( realpath "${PROJECT_ROOT}/src/cecho.bash" )"
}

@test "success on dot command of BASH_SOURCE path with origin specified." {
    source "${PROJECT_ROOT}/src/realpath.bash"
    run sourced-file-path --origin="${PROJECT_ROOT}/src/realpath_check.bash"  '. ${BASH_SOURCE[0]%/*}/cecho.bash'
    assert_success
    assert_output "$( realpath "${PROJECT_ROOT}/src/cecho.bash" )"
}
