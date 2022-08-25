#!/usr/bin/env bash

DIRNAME=$(dirname $0)

source "${DIRNAME}/spotify_status_vars"

PARENT_BAR_PID=$(pgrep -a "polybar" | grep "$PARENT_BAR" | cut -d" " -f1)

update_hooks() {
    local pid
    local pids="$1"
    local message="$2"

    echo "$pids" | while IFS='\n' read pid; do
        polybar-msg -p "$pid" hook spotify-play-pause $message 1>/dev/null 2>&1
    done
}

if [[ ! -d $CACHE_DIR ]]; then
    mkdir -p $CACHE_DIR
fi

if [[ ! -f $STATUS_CACHE ]]; then
    touch $STATUS_CACHE
fi

if [[ ! -f $FORMAT_CACHE ]]; then
    touch $FORMAT_CACHE
fi

STATUS=$(cat $STATUS_CACHE)

if [ "$1" == "--status" ]; then
    echo "$STATUS"
else
    if [ "$STATUS" = "Stopped" ]; then
        echo "No music is playing"
    elif [ "$STATUS" = "Paused"  ]; then
        update_hooks "$PARENT_BAR_PID" 2
        cat $FORMAT_CACHE
    elif [ "$STATUS" = "No player is running"  ]; then
        echo "$STATUS"
    else
        update_hooks "$PARENT_BAR_PID" 1
        cat $FORMAT_CACHE
    fi
fi

