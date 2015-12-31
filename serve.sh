#!/bin/bash

# Parse request
read LINE
REGEX='^(HEAD|GET) /([a-zA-Z0-9_]*) (HTTP/[0-9].[0-9])\s?$'
[[ "$LINE" =~ $REGEX ]]
NAME=${BASH_REMATCH[2]}
HTTP=${BASH_REMATCH[3]}
response () {
	echo "${HTTP:-HTTP/1.1} $1"
	exit 0
}

# No name given
[[ -z "$NAME" ]] && response "400 Bad Request"

# Check if NAME is available
[[ "$(docker inspect --format='{{.State.Status}}' "$NAME" 2>/dev/null)" = "running" ]] && response "200 OK"

# Not available
response "503 Service Unavailable"
