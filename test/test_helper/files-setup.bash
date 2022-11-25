#!/usr/bin/env bash

# Files test environment setup.
_files_setup() {
    # Load bats-file helper library.
    if [[ -e "${BASH_SOURCE[0]%/*}/bats-file/load.bash" ]]; then
      load "${BASH_SOURCE[0]%/*}/bats-file/load"
    elif [[ -e "/usr/lib/bats-file/load.bash" ]]; then
      load "/usr/lib/bats-file/load"
    fi

    local prefix=""

    EXISTING_FILE="$( mktemp )"
    
    # On MacOS /var is a symbolic link to /private/var.
    if [[ -e "/private${EXISTING_FILE}" ]]; then
      prefix="/private"
      EXISTING_FILE="${prefix}${EXISTING_FILE}"
    fi

    MISSING_FILE="${prefix}$( mktemp -u )"
    LN_TO_MISSING_FILE="${prefix}$( mktemp -u )"
    ln -s "${MISSING_FILE}" "${LN_TO_MISSING_FILE}"

    # shellcheck disable=SC2034
    EXISTING_DASH_FILE="${prefix}$( mktemp -t -- '-tmp.XXXXXXXXX' )"
    LN_TO_EXISTING_FILE="${prefix}$( mktemp -u )"
    ln -s "${EXISTING_FILE}" "${LN_TO_EXISTING_FILE}"

    EXISTING_FILE_DIRNAME="${EXISTING_FILE%/*}"
    EXISTING_FILE_BASENAME="${EXISTING_FILE##*/}"
    # shellcheck disable=SC2034
    EXISTING_FILE_RELATIVE_PATH="${EXISTING_FILE_DIRNAME}/./${EXISTING_FILE_BASENAME}"
}

# Files test environment teardown.
_files_teardown() {
    [[ -e "${MISSING_FILE}" ]] && rm "${MISSING_FILE}"
    [[ -e "${LN_TO_MISSING_FILE}" ]] && rm "${LN_TO_MISSING_FILE}"
    
    [[ -e "${EXISTING_FILE}" ]] && rm "${EXISTING_FILE}"
    [[ -e "${LN_TO_EXISTING_FILE}" ]] && rm "${LN_TO_EXISTING_FILE}"

    return 0
}
