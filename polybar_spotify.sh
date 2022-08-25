#!/usr/bin/env bash

DIRNAME=$(dirname $0)

trap 'kill 0' EXIT

${DIRNAME}/update_spotify_status_cache.sh &
${DIRNAME}/scroll_spotify_status.sh &

wait

