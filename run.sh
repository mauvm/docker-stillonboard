#!/bin/sh

socat tcp-l:8080,reuseaddr,fork EXEC:/serve.sh &
tail -f /log.txt
