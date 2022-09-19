#!/usr/bin/env bash

trap 'kill 0' EXIT

readonly DIRNAME=$(dirname $0)

source "${DIRNAME}/spotify_status_vars"

readonly STATUS_PLAYING='Playing'
readonly STATUS_PAUSED='Paused'
readonly STATUS_STOPPED='Stopped'
readonly STATUS_NO_PLAYER='No player'

function update_cache_files() {
  local status=$(playerctl --player=$PLAYER status 2>/dev/null)
  local exit_code=$?
  
  if [[ $exit_code -ne 0 ]]; then
    status='No player'
  fi
  
  echo "${status}" > "${STATUS_CACHE_FILE}.tmp"
  mv "${STATUS_CACHE_FILE}.tmp" "${STATUS_CACHE_FILE}"
  
  playerctl --player=$PLAYER metadata --format "$FORMAT" > "${FORMAT_CACHE_FILE}.tmp" 2>/dev/null
  mv "${FORMAT_CACHE_FILE}.tmp" "${FORMAT_CACHE_FILE}"
}

if [[ ! -d $CACHE_DIR ]]; then
  mkdir -p "${CACHE_DIR}"
fi

if [[ ! -f $STATUS_CACHE_FILE ]]; then
  touch "${STATUS_CACHE_FILE}"
fi

if [[ ! -f $FORMAT_CACHE_FILE ]]; then
  touch "${FORMAT_CACHE_FILE}"
fi

while true; do
  update_cache_files
  sleep "${CACHE_UPDATE_INTERVAL}"
done &

zscroll \
  -l 30 \
  --delay 0.1 \
  --scroll-padding " | " \
  --match-command "${DIRNAME}/get_spotify_status.sh --status" \
  --match-text "${STATUS_PLAYING}"   "--scroll 1 --before-text '阮 '" \
  --match-text "${STATUS_PAUSED}"    "--scroll 0 --before-text '阮 %{F#71839b}' --after-text '%{F-}'" \
  --match-text "${STATUS_STOPPED}"   "--scroll 0 --before-text '%{F#71839b}阮 ' --after-text '%{F-}'" \
  --match-text "${STATUS_NO_PLAYER}" "--scroll 0 --before-text '%{F#71839b}阮 ' --after-text '%{F-}'" \
  --update-check=true "${DIRNAME}/get_spotify_status.sh" &

wait
