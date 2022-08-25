#!/usr/bin/env bash

DIRNAME=$(dirname $0)

source "${DIRNAME}/spotify_status_vars"

trap 'kill 0' EXIT

while true; do
    PLAYERCTL_STATUS=$(playerctl --player=$PLAYER status 2>/dev/null)
    EXIT_CODE=$?
    
    if [ $EXIT_CODE -eq 0 ]; then
        STATUS=$PLAYERCTL_STATUS
    else
        STATUS="No player is running"
    fi

    echo $STATUS > "${STATUS_CACHE}.tmp"
    mv "${STATUS_CACHE}.tmp" "${STATUS_CACHE}"

    sleep $CACHE_UPDATE_INTERVAL
done &

while true; do
    playerctl --player=$PLAYER metadata --format "$FORMAT" > "${FORMAT_CACHE}.tmp" 2>/dev/null
    mv "${FORMAT_CACHE}.tmp" "${FORMAT_CACHE}"
    sleep $CACHE_UPDATE_INTERVAL
done &

wait

