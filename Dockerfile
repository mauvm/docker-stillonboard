FROM alpine:3.3
MAINTAINER Maurits van Mastrigt <maurits@nerdieworks.nl>

RUN apk add --update bash socat jq \
	&& rm -rf /var/cache/apk/*

COPY run.sh /
COPY serve.sh /
RUN chmod +x /run.sh /serve.sh
RUN touch /log.txt

EXPOSE 8080
CMD /run.sh
