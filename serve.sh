#!/bin/bash

log () {
	echo "[$(date +'%Y-%m-%d %H:%M:%S%z')] $@" >> /log.txt
}
response () {
	log "Response for '$NAME': $1"
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
is_truthy () {
	echo -n "$@" | grep -iqwE '^(y(es)?|true|1)$'
}
is_falsy () {
	echo -n "$@" | grep -iqwE '^(no?|false|0)$'
}

# Parse request
read LINE
log "Request: $LINE"
REGEX='^(HEAD|GET) /([a-zA-Z0-9_]*) (HTTP/[0-9].[0-9])\s?$'
[[ "$LINE" =~ $REGEX ]]
NAME=${BASH_REMATCH[2]}
HTTP=${BASH_REMATCH[3]}

# No name given
[ -z "$NAME" ] && response '400 Bad Request'

# Black- and whitelisting
NAME_UPPER=$(echo -n "ALLOW_$NAME" | awk '{print toupper($0)}')
LISTED_AS=${!NAME_UPPER}

if is_truthy $LISTED_AS ; then : # Noop
elif is_falsy $LISTED_AS; then response '503 Service Unavailable'
elif is_falsy $ALLOW    ; then response '503 Service Unavailable'
fi

# Check if NAME is available
[ "$(echo -e "GET /containers/json HTTP/1.1\r\n" \
	| socat unix-connect:/var/run/docker.sock STDIO \
	| grep '\[{' | jq '.[].Names[]' 2>/dev/null \
	| grep -i "\"\/$NAME\"" | wc -l)" = '1' ] \
	&& response '200 OK'

# Not available
response '503 Service Unavailable'
