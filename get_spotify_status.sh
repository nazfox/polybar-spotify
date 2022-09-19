#!/usr/bin/env bash

readonly DIRNAME=$(dirname $0)

source "${DIRNAME}/spotify_status_vars"

readonly HOOK_PLAYING=0
readonly HOOK_PAUSED=1
readonly HOOK_DISABLED=2

readonly STATUS_PAUSED='Paused'
readonly STATUS_PLAYING='Playing'
readonly STATUS_STOPPED='Stopped'
readonly STATUS_NO_PLAYER='No player'

readonly POLYBAR_PID=$(pgrep -a 'polybar' | grep "${POLYBAR_NAME}" | cut -d' ' -f1)

readonly PLAYER_STATUS=$(cat "${STATUS_CACHE_FILE}")

run_hooks() {
  local pid
  local pids="$1"
  local hook_n="$2"

  echo "$pids" | while IFS='\n' read pid; do
    polybar-msg -p "${pid}" action "#spotify-prev.hook.${hook_n}"       1>/dev/null 2>&1
    polybar-msg -p "${pid}" action "#spotify-play-pause.hook.${hook_n}" 1>/dev/null 2>&1
    polybar-msg -p "${pid}" action "#spotify-next.hook.${hook_n}"       1>/dev/null 2>&1
  done
}

if [[ "$1" == '--status' ]]; then
  echo "${PLAYER_STATUS}"
else
  if [[ "${PLAYER_STATUS}" = "${STATUS_STOPPED}" ]]; then
    run_hooks "${POLYBAR_PID}" $HOOK_DISABLED
    echo "No music is playing"
  elif [[ "${PLAYER_STATUS}" = "${STATUS_PAUSED}" ]]; then
    run_hooks "${POLYBAR_PID}" $HOOK_PAUSED
    cat "${FORMAT_CACHE_FILE}"
  elif [[ "${PLAYER_STATUS}" = "${STATUS_NO_PLAYER}" ]]; then
    run_hooks "${POLYBAR_PID}" $HOOK_DISABLED
    echo "No player is running"
  elif [[ "${PLAYER_STATUS}" = "${STATUS_PLAYING}" ]]; then
    run_hooks "${POLYBAR_PID}" $HOOK_PLAYING
    cat "${FORMAT_CACHE_FILE}"
  else
    run_hooks "${POLYBAR_PID}" $HOOK_DISABLED
    echo "Cannot handle status ${PLAYER_STATUS}"
  fi
fi
