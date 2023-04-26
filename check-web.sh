#!/bin/bash

# https://github.com/Start9Labs/cryptpad-wrapper/blob/master/check-web.sh

DURATION=$(</dev/stdin)
if (($DURATION <= 5000)); then
    exit 60
else
    if ! curl --silent --fail bitclock.embassy:3000 &>/dev/null; then
        echo "Web interface is unreachable" >&2
        exit 1
    fi
fi