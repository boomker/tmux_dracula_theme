#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

# configuration
# @dracula-ping-server "example.com"
# @dracula-ping-rate 5

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${current_dir}/utils.sh"

get_jobs() {
  case $(uname -s) in
  Linux | Darwin)
    JOBS="$(ps -e -o command,state,tty  |awk '{if($(NF-1) ~ /T/ && $NF ~ /ttys00/)print $0}' |wc -l)"
    echo jobs: "${JOBS}"
    ;;

  CYGWIN* | MINGW32* | MSYS* | MINGW*)
    # TODO - windows compatability
    ;;
  esac
}

main() {

  echo $(get_jobs)
  # RATE=$(get_tmux_option "@dracula-ping-rate" 5)
  # sleep $RATE
}

# run main driver
main
