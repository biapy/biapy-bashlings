#!/usr/bin/env bats
# test/download.bats
# Test src/download.bash:download function.

# shellcheck source-path=SCRIPTDIR../src

# Setup test environment.
setup() {
  # Load bats libraries.
  load 'test_helper/common-setup'
  load 'test_helper/files-setup'

  _common_setup
  _files_setup

  # Sourcing download.bash
  source "${PROJECT_ROOT}/src/download.bash"

  WORKING_URL="https://raw.githubusercontent.com/github/gitignore/5342e13bc99d1e106b4d5f7bc9e9deaa0c58543e/Ada.gitignore"
  WORKING_URL_CONTENTS=(
    "# Object file"
    "*.o"
    ""
    "# Ada Library Information"
    "*.ali"
  )
  ERROR_404_URL="https://google.com/404"

  # Create a random User Agent
  # RANDOM_USER_AGENT="$( command tr --complement --delete \
  #         '[:alnum:]#%(),-' \
  #         2>'/dev/null' < '/dev/urandom' \
  #     | command head --bytes=64
  # )"
  RANDOM_USER_AGENT="cshqS1u%0q(MwSF2HAJtqwpdHqAFkcxhANNqcULOT4X(-O7YOE))t)arVVBV#8y"
}

# Teardown test environment.
teardown() {
  _common_teardown
}

# bats file_tags=function:download,scope:public

@test "fail for missing URL" {
  run download
  assert_failure
  assert_output "Error: download requires URL."
}

@test "fail silently for missing URL" {
  run download --quiet
  assert_failure
  assert_output ""
}

@test "fail for empty URL" {
  run download ""
  assert_failure
  assert_output "Error: download requires URL."
}

@test "fail for empty URL (--url)" {
  run download --url=""
  assert_failure
  assert_output "Error: download requires URL."
}

@test "fail silently for empty URL (-q)" {
  run download -q ""
  assert_failure
  assert_output ""
}

@test "fail silently for empty URL (--quiet)" {
  run download --quiet ""
  assert_failure
  assert_output ""
}

@test "fail for unknown option" {
  run download --unknown-option "${WORKING_URL}"
  assert_failure
  assert_output "Error: option '--unknown-option' is not recognized."
}

@test "fail silently for unknown option" {
  run download --quiet --unknown-option "${WORKING_URL}"
  assert_failure
  assert_output ""
}

@test "fail for both --url and \$1 argument" {
  run download --url="${ERROR_404_URL}" "${ERROR_404_URL}"
  assert_failure
  assert_output "Error: either provide URL via --url or \$1, not both."
}

@test "fail silently for both --url and \$1 argument" {
  run download --quiet --url="${ERROR_404_URL}" "${ERROR_404_URL}"
  assert_failure
  assert_output ""
}

@test "fail for too many arguments (with --url)" {
  run download --url="${ERROR_404_URL}" "${ERROR_404_URL}" "dummy"
  assert_failure
  assert_output "Error: download accept at most one argument, or --url option."
}

@test "fail silently for too many arguments (with --url)" {
  run download --quiet --url="${ERROR_404_URL}" "${ERROR_404_URL}" "dummy"
  assert_failure
  assert_output ""
}

@test "fail for too many arguments (without --url)" {
  run download "${ERROR_404_URL}" "dummy"
  assert_failure
  assert_output "Error: download accept at most one argument, or --url option."
}

@test "fail for 404 URL (as argument)" {
  run download "${ERROR_404_URL}"
  assert_failure
  assert_output "Error: download failed."
}

@test "fail for 404 URL" {
  run download --url="${ERROR_404_URL}"
  assert_failure
  assert_output "Error: download failed."
}

@test "fail silently for 404 URL (-q)" {
  run download -q --url="${ERROR_404_URL}"
  assert_failure
  assert_output ""
}

@test "fail silently for 404 URL (--quiet)" {
  run download --quiet --url="${ERROR_404_URL}"
  assert_failure
  assert_output ""
}

@test "success for simple HTTPS URL" {
  bats_require_minimum_version '1.5.0'
  # Check specific commit content for small file.
  run --keep-empty-lines download \
    --url="${WORKING_URL}"
  assert_success
  assert_line --index 0 "${WORKING_URL_CONTENTS[0]}"
  assert_line --index 1 "${WORKING_URL_CONTENTS[1]}"
  assert_line --index 2 "${WORKING_URL_CONTENTS[2]}"
  assert_line --index 3 "${WORKING_URL_CONTENTS[3]}"
  assert_line --index 4 "${WORKING_URL_CONTENTS[4]}"
}

@test "success for simple HTTPS URL with dash output" {
  bats_require_minimum_version '1.5.0'
  # Check specific commit content for small file.
  run --keep-empty-lines download --outputPath=- \
    --url="${WORKING_URL}"
  assert_success
  assert_line --index 0 "${WORKING_URL_CONTENTS[0]}"
  assert_line --index 1 "${WORKING_URL_CONTENTS[1]}"
  assert_line --index 2 "${WORKING_URL_CONTENTS[2]}"
  assert_line --index 3 "${WORKING_URL_CONTENTS[3]}"
  assert_line --index 4 "${WORKING_URL_CONTENTS[4]}"
}

@test "success for simple HTTPS URL with output to file" {
  # Check specific commit content for small file.
  run download \
    --output-path="${MISSING_FILE}" \
    --url="${WORKING_URL}"
  assert_success
  assert_output ''
  assert_file_exists "${MISSING_FILE}"
  assert_file_not_empty "${MISSING_FILE}"

  # Bash 4 version: mapfile -t "file_contents" < "${MISSING_FILE}"
  unset -v 'file_contents'
  declare -a file_contents=()
  # shellcheck disable=SC2030,SC2031
  while IFS='' read -r; do file_contents+=("${REPLY}"); done < "${MISSING_FILE}"
  [[ ${REPLY} ]] && file_contents+=("${REPLY}")

  [[ "${file_contents[0]}" = "${WORKING_URL_CONTENTS[0]}" ]]
  [[ "${file_contents[1]}" = "${WORKING_URL_CONTENTS[1]}" ]]
  [[ "${file_contents[2]}" = "${WORKING_URL_CONTENTS[2]}" ]]
  [[ "${file_contents[3]}" = "${WORKING_URL_CONTENTS[3]}" ]]
  [[ "${file_contents[4]}" = "${WORKING_URL_CONTENTS[4]}" ]]
}

@test "success for simple HTTPS URL with deprecated output to file" {
  # Check specific commit content for small file.
  run download \
    --outputPath="${MISSING_FILE}" \
    --url="${WORKING_URL}"
  assert_success
  assert_output ''
  assert_file_exists "${MISSING_FILE}"
  assert_file_not_empty "${MISSING_FILE}"

  # Bash 4 version: mapfile -t "file_contents" < "${MISSING_FILE}"
  unset -v 'file_contents'
  declare -a file_contents=()
  # shellcheck disable=SC2030,SC2031
  while IFS='' read -r; do file_contents+=("${REPLY}"); done < "${MISSING_FILE}"
  [[ ${REPLY} ]] && file_contents+=("${REPLY}")

  [[ "${file_contents[0]}" = "${WORKING_URL_CONTENTS[0]}" ]]
  [[ "${file_contents[1]}" = "${WORKING_URL_CONTENTS[1]}" ]]
  [[ "${file_contents[2]}" = "${WORKING_URL_CONTENTS[2]}" ]]
  [[ "${file_contents[3]}" = "${WORKING_URL_CONTENTS[3]}" ]]
  [[ "${file_contents[4]}" = "${WORKING_URL_CONTENTS[4]}" ]]
}

@test "fail for 404 URL and remove file" {
  run download \
    --output-path="${EXISTING_FILE}" \
    --url="${ERROR_404_URL}"
  assert_failure
  assert_output 'Error: download failed.'
  assert_file_not_exists "${EXISTING_FILE}"
}

@test "success for user agent change" {
  # Use a user-agent checking web service.
  run download --user-agent="${RANDOM_USER_AGENT}" \
    --url="https://www.whatsmyua.info/"
  assert_success
  assert_output --partial "${RANDOM_USER_AGENT}"
}

@test "success for deprecated user agent change" {
  # Use a user-agent checking web service.
  run download --userAgent="${RANDOM_USER_AGENT}" \
    --url="https://www.whatsmyua.info/"
  assert_success
  assert_output --partial "${RANDOM_USER_AGENT}"
}

@test "check verbose mode" {
  run download --verbose --url="${ERROR_404_URL}"
  assert_failure
  assert_output --partial "Info: download: checking for wget or curl."
}

@test "--wget: check verbose mode" {
  run download --wget --verbose --url="${ERROR_404_URL}"
  assert_failure
  assert_output --partial "Info: download: checking for wget."
}

@test "--curl: check verbose mode" {
  run download --curl --verbose --url="${ERROR_404_URL}"
  assert_failure
  assert_output --partial "Info: download: checking for curl."
}

@test "--wget: fail for 404 URL" {
  run download --wget --url="${ERROR_404_URL}"
  assert_failure
  assert_output "Error: download failed."
}

@test "--wget: fail silently for 404 URL (-q)" {
  run download --wget -q --url="${ERROR_404_URL}"
  assert_failure
  assert_output ""
}

@test "--wget: fail silently for 404 URL (--quiet)" {
  run download --wget --quiet --url="${ERROR_404_URL}"
  assert_failure
  assert_output ""
}

@test "--wget: success for simple HTTPS URL" {
  bats_require_minimum_version '1.5.0'
  # Check specific commit content for small file.
  run --keep-empty-lines download --wget \
    --url="${WORKING_URL}"
  assert_success
  assert_line --index 0 "${WORKING_URL_CONTENTS[0]}"
  assert_line --index 1 "${WORKING_URL_CONTENTS[1]}"
  assert_line --index 2 "${WORKING_URL_CONTENTS[2]}"
  assert_line --index 3 "${WORKING_URL_CONTENTS[3]}"
  assert_line --index 4 "${WORKING_URL_CONTENTS[4]}"
}

@test "--wget: success for simple HTTPS URL with output to file" {
  # Check specific commit content for small file.
  run download --wget \
    --output-path="${MISSING_FILE}" \
    --url="${WORKING_URL}"
  assert_success
  assert_output ''
  assert_file_exists "${MISSING_FILE}"
  assert_file_not_empty "${MISSING_FILE}"

  # Bash 4 version: mapfile -t "file_contents" < "${MISSING_FILE}"
  unset -v 'file_contents'
  declare -a file_contents=()
  # shellcheck disable=SC2030,SC2031
  while IFS='' read -r; do file_contents+=("${REPLY}"); done < "${MISSING_FILE}"
  [[ ${REPLY} ]] && file_contents+=("${REPLY}")

  [[ "${file_contents[0]}" = "${WORKING_URL_CONTENTS[0]}" ]]
  [[ "${file_contents[1]}" = "${WORKING_URL_CONTENTS[1]}" ]]
  [[ "${file_contents[2]}" = "${WORKING_URL_CONTENTS[2]}" ]]
  [[ "${file_contents[3]}" = "${WORKING_URL_CONTENTS[3]}" ]]
  [[ "${file_contents[4]}" = "${WORKING_URL_CONTENTS[4]}" ]]
}

@test "--wget: fail for 404 URL and remove file" {
  run download --wget \
    --output-path="${EXISTING_FILE}" \
    --url="${ERROR_404_URL}"
  assert_failure
  assert_output 'Error: download failed.'
  assert_file_not_exists "${EXISTING_FILE}"
}

@test "--wget: success for user agent change" {
  # Use a user-agent checking web service.
  run download --wget --user-agent="${RANDOM_USER_AGENT}" \
    --url="https://www.whatsmyua.info/"
  assert_success
  assert_output --partial "${RANDOM_USER_AGENT}"
}

@test "--curl: fail for 404 URL" {
  run download --curl --url="${ERROR_404_URL}"
  assert_failure
  assert_output "Error: download failed."
}

@test "--curl: fail silently for 404 URL (-q)" {
  run download --curl -q --url="${ERROR_404_URL}"
  assert_failure
  assert_output ""
}

@test "--curl: fail silently for 404 URL (--quiet)" {
  run download --curl --quiet --url="${ERROR_404_URL}"
  assert_failure
  assert_output ""
}

@test "--curl: success for simple HTTPS URL" {
  bats_require_minimum_version '1.5.0'
  # Check specific commit content for small file.
  run --keep-empty-lines download --curl \
    --url="${WORKING_URL}"
  assert_success
  assert_line --index 0 "${WORKING_URL_CONTENTS[0]}"
  assert_line --index 1 "${WORKING_URL_CONTENTS[1]}"
  assert_line --index 2 "${WORKING_URL_CONTENTS[2]}"
  assert_line --index 3 "${WORKING_URL_CONTENTS[3]}"
  assert_line --index 4 "${WORKING_URL_CONTENTS[4]}"
}

@test "--curl: success for simple HTTPS URL with output to file" {
  # Check specific commit content for small file.
  run download --curl \
    --output-path="${MISSING_FILE}" \
    --url="${WORKING_URL}"
  assert_success
  assert_output ''
  assert_file_exists "${MISSING_FILE}"
  assert_file_not_empty "${MISSING_FILE}"

  # Bash 4 version: mapfile -t "file_contents" < "${MISSING_FILE}"
  unset -v 'file_contents'
  declare -a file_contents=()
  # shellcheck disable=SC2030,SC2031
  while IFS='' read -r; do file_contents+=("${REPLY}"); done < "${MISSING_FILE}"
  [[ ${REPLY} ]] && file_contents+=("${REPLY}")

  [[ "${file_contents[0]}" = "${WORKING_URL_CONTENTS[0]}" ]]
  [[ "${file_contents[1]}" = "${WORKING_URL_CONTENTS[1]}" ]]
  [[ "${file_contents[2]}" = "${WORKING_URL_CONTENTS[2]}" ]]
  [[ "${file_contents[3]}" = "${WORKING_URL_CONTENTS[3]}" ]]
  [[ "${file_contents[4]}" = "${WORKING_URL_CONTENTS[4]}" ]]
}

@test "--curl: fail for 404 URL and remove file" {
  run download --curl \
    --output-path="${EXISTING_FILE}" \
    --url="${ERROR_404_URL}"
  assert_failure
  assert_output 'Error: download failed.'
  assert_file_not_exists "${EXISTING_FILE}"
}

@test "--curl: success for user agent change" {
  # Use a user-agent checking web service.
  run download --curl --user-agent="${RANDOM_USER_AGENT}" \
    --url="https://www.whatsmyua.info/"
  assert_success
  assert_output --partial "${RANDOM_USER_AGENT}"
}
