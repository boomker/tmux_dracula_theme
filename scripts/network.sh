#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

HOSTS="qq.com github.com "

get_ssid()
{
  # Check OS
  case $(uname -s) in
    Linux)
      SSID=$(iw dev | sed -nr 's/^\t\tssid (.*)/\1/p')
      if [ -n "$SSID" ]; then
        printf '%s' "$SSID"
      else
        echo 'Ethernet'
      fi
      ;;

    Darwin)
      AIRPORT_PATH="/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport"
      if "${AIRPORT_PATH}" -I | grep -E ' SSID' | cut -d ':' -f 2 | sed 's/ ^*//g' &> /dev/null; then
        # echo "$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | grep -E ' SSID' | cut -d ':' -f 2)" | sed 's/ ^*//g'
        SSID="$("${AIRPORT_PATH}" -I | grep -E ' SSID' | cut -d ':' -f 2 | sed 's/ ^*//g')"
        IPADDR="$(osascript -e "IPv4 address of (system info)")"
        echo "${SSID}:${IPADDR} "
      else
        echo 'Ethernet'
      fi
      ;;

    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      # leaving empty - TODO - windows compatability
      ;;

    *)
      ;;
  esac

}

main()
{
  network="Offline:127.0.0.1"
  for host in $HOSTS; do
    if ping -q -c 1 -W 1 $host &>/dev/null; then
      network="$(get_ssid)"
      break
    fi
  done

  echo "$network"
}

#run main driver function
main
