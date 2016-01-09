#!/bin/bash

# Parse request
read LINE
REGEX='^(HEAD|GET) /([a-zA-Z0-9_]*) (HTTP/[0-9].[0-9])\s?$'
[[ "$LINE" =~ $REGEX ]]
NAME=${BASH_REMATCH[2]}
HTTP=${BASH_REMATCH[3]}
response () {
	DATE=$(date +"%a, %d %b %Y %H:%M:%S %Z")
	echo "${HTTP:-HTTP/1.1} $1"
	echo "Date: $DATE"
	echo "Server: stillonboard"
	echo "Access-Control-Allow-Origin: *"
	echo "Content-Length: 0"
	echo "Content-Type: text/plain; charset=utf-8"
	echo
	exit 0
}

# No name given
[[ -z "$NAME" ]] && response "400 Bad Request"

# Check if NAME is available
[ "$(echo -e "GET /containers/json HTTP/1.1\r\n" \
	| socat unix-connect:/var/run/docker.sock STDIO \
	| grep '\[{' | jq '.[].Names[]' 2>/dev/null \
	| grep "\"\/$NAME\"" | wc -l)" = "1" ] \
	&& response "200 OK"

# Not available
response "503 Service Unavailable"
