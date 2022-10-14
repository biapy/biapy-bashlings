#!/usr/bin/env bash

# Files test environment setup.
_files_setup() {
    MISSING_FILE="$( mktemp --dry-run )"
    LN_TO_MISSING_FILE="$( mktemp --dry-run )"
    ln -s "${MISSING_FILE}" "${LN_TO_MISSING_FILE}"

    EXISTING_FILE="$( mktemp )"
    EXISTING_DASH_FILE="$( mktemp -t -- '-tmp.XXXXXXXXX' )"
    LN_TO_EXISTING_FILE="$( mktemp --dry-run )"
    ln -s "${EXISTING_FILE}" "${LN_TO_EXISTING_FILE}"

    EXISTING_FILE_DIRNAME="$( dirname "${EXISTING_FILE}" )"
    EXISTING_FILE_BASENAME="$( basename "${EXISTING_FILE}" )"
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
