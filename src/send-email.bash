#!/usr/bin/env bash
# @file src/send-email.bash
# @author Pierre-Yves Landuré < contact at biapy dot fr >
# @brief Send an email using sendmail.
# @description
#   `send-email` is a `sendmail` wrapper adding support for UTF-8 characters
#   in the headers.

# shellcheck source-path=SCRIPTDIR
source "${BASH_SOURCE[0]%/*}/available-fd.bash"
source "${BASH_SOURCE[0]%/*}/cecho.bash"
source "${BASH_SOURCE[0]%/*}/check-binary.bash"
source "${BASH_SOURCE[0]%/*}/in-list.bash"
source "${BASH_SOURCE[0]%/*}/process-options.bash"

# @description
#   Send an email with UTF-8 characters in the headers.
#
# @example
#   source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/send-email.bash"
#   echo "Email Contents" |
#     send-email --from="from@domain.com" --subject="Email subject" \\
#       "recipient1@domain.com" "recipient2@domain.com"
#
# @option --content-type=<html|plain> set thee email content MIME type: `html` or `plain` (default).
# @option --from=<email> set the sender email.
# @option --subject=<subject> set the email subject.
# @option --contents=<contents|path|-> set the email contents or its source (default to `/dev/stdin``).
#   use `-` (dash) to read contents from stdin.
# @arg $@ list of recipient email addresses.
#
# @exitcode 0 If email is successfully sent.
# @exitcode 1 If argument is missing.
#
# @stderr Error if the argument is missing or more than one argument is given.
#
# @see [cecho](./cecho.md#cecho)
# @see [check-binary](./check-binary.md#check-binary)
# @see [process-options](./process-options.md#process-options)
# @see [How to send special characters via mail from a shell script? @ Stack Overflow](https://stackoverflow.com/questions/3120168/how-to-send-special-characters-via-mail-from-a-shell-script)
# @see [Trouble Sending file content in the mail body with mailx @ StackOverflow](https://unix.stackexchange.com/questions/471311/trouble-sending-file-content-in-the-mail-body-with-mailx).
function send-email() {
  local quiet=0
  local q=0
  local verbose=0
  local v=0
  local content_type='plain'
  local from
  local subject
  local contents='-'
  local allowed_options=('q' 'quiet' 'v' 'verbose')
  local mail_command_path
  local encoded_contents
  local encoded_subject

  allowed_options+=('from+' 'subject+' 'contents&' 'content-type&')

  local arguments=()

  # Detect if quiet mode is enabled, to allow for process-optins silencing.
  in-list "(-q|--quiet)" ${@+"$@"} && quiet=1
  in-list "(-v|--verbose)" ${@+"$@"} && verbose=1

  if error_fd="$(available-fd '2')"; then
    ((quiet)) && fd_target='/dev/null' || fd_target='&2'
    eval "exec ${error_fd-2}>${fd_target-&2}"
  fi

  if verbose_fd="$(available-fd '2')"; then
    ((verbose)) && fd_target='&2' || fd_target='/dev/null'
    eval "exec ${verbose_fd-2}>${fd_target-'/dev/null'}"
    cecho "DEBUG" "Debug: ${FUNCNAME[0]}'s verbose mode enabled." >&"${verbose_fd-2}"
  fi

  # Function closing error redirection file descriptors.
  # to be called before exiting this function.
  close-fds() {
    [[ "${error_fd-2}" -ne 2 ]] && eval "exec ${error_fd-}>&-"
    [[ "${verbose_fd-2}" -ne 2 ]] && eval "exec ${verbose_fd-}>&-"
  }

  # Call the process-options function:
  if ! process-options "${allowed_options[*]}" ${@+"$@"} 2>&"${error_fd}"; then
    close-fds
    return 1
  fi

  if [[ -z "${from}" ]]; then
    cecho 'ERROR' "Error: ${FUNCNAME[0]} requires a from email address." >&"${error_fd}"
    close-fds
    return 1
  fi

  if [[ -z "${subject}" ]]; then
    cecho 'ERROR' "Error: ${FUNCNAME[0]} requires a subject." >&"${error_fd}"
    close-fds
    return 1
  fi

  if [[ "${#arguments[@]}" -eq 0 ]]; then
    cecho 'ERROR' "Error: ${FUNCNAME[0]} requires a least one recipient email address." >&"${error_fd}"
    close-fds
    return 1
  fi

  cecho 'INFO' "Info: download: checking for sendmail or bsd-mailx." >&"${verbose_fd}"

  # Check for wget or curl presence,
  # Exit with error if check-binary failed.
  if ! mail_command_path="$(check-binary "sendmail;bsd-mailx" "bsd-mailx")"; then
    close-fds
    return 1
  fi

  quiet=$((quiet + q))
  verbose=$((verbose + v))

  encoded_contents="$(base64 <<<"${contents}")"
  encoded_subject="=?utf-8?B?$(base64 --wrap=0 <<<"${subject}")?="

  for recipient in "${@}"; do
    if [[ -n "${recipient}" ]]; then
      case "${mail_command_path##*/}" in
      'sendmail')
        sendmail -f "${from}" "${recipient}" <<EOF
Subject: ${encoded_subject}
MIME-Version: 1.0
From: ${from}
To: ${recipient}
Content-Type: text/${content_type}; charset=\"utf-8\"
Content-Transfer-Encoding: base64
Content-Disposition: inline

${encoded_contents}
EOF
        return "${?}"
        ;;

      'bsd-mailx')
        bsd-mailx -s "${encoded_subject}" \
          -a "From: ${from}" \
          -a "Content-Type: text/${content_type}; charset=\"utf-8\"" \
          -a "Content-Transfer-Encoding: base64" \
          -a "Content-Disposition: inline" \
          "${recipient}" <<<"${encoded_contents}"
        ;;
      *)
        cecho 'ERROR' "Error: unable to determine mail sending command." >&"${error_fd}"
        close-fds
        return 1
        ;;
      esac
    fi
  done

  return 0
}
