#!/usr/bin/env bash

DIRNAME=$(dirname $0)

# see man zscroll for documentation of the following parameters
zscroll -l 30 \
        --delay 0.1 \
        --scroll-padding " | " \
        --match-command "${DIRNAME}/get_spotify_status_from_cache.sh --status" \
        --match-text "Playing" "--scroll 1 --before-text '阮 '" \
        --match-text "Paused"  "--scroll 0 --before-text '阮 %{F#71839b}' --after-text '%{F-}'" \
        --match-text "Stopped" "--scroll 0 --before-text '%{F#71839b}阮 ' --after-text '%{F-}'" \
        --update-check=true "${DIRNAME}/get_spotify_status_from_cache.sh"

