FROM looztra/alpine-docker-client
MAINTAINER Maurits van Mastrigt <maurits@nerdieworks.nl>

RUN apk add --update socat \
	&& rm -rf /var/cache/apk/*

COPY serve.sh /serve
RUN chmod +x /serve

EXPOSE 9000
CMD socat tcp-l:9000,reuseaddr,fork EXEC:/serve
