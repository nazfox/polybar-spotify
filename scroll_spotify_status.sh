#!/usr/bin/env bash

DIRNAME=$(dirname $0)

# see man zscroll for documentation of the following parameters
zscroll -l 30 \
        --delay 0.1 \
        --scroll-padding " | " \
        --match-command "${DIRNAME}/get_spotify_status_from_cache.sh --status" \
        --match-text "Playing" "--scroll 1" \
        --match-text "Paused" "--scroll 0" \
        --update-check=true "${DIRNAME}/get_spotify_status_from_cache.sh"

