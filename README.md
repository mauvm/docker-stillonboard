# Still On Board

> Ultra lightweight Docker status reporter (~9.2MB for full image).

A Bash webserver that inspects a Docker container (by given name, case insensitive) to check if it's still running.

[![](https://images.microbadger.com/badges/image/mauvm/stillonboard.svg)](https://microbadger.com/images/mauvm/stillonboard "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/mauvm/stillonboard.svg)](https://microbadger.com/images/mauvm/stillonboard "Get your own version badge on microbadger.com")

## How to use

```bash
docker run -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock --name stillonboard mauvm/stillonboard:0.2
curl -v localhost:8080/stillonboard     # 200 OK
curl -v localhost:8080/other_container  # 503 Service Unavailable
# curl -v localhost:8080/<container name or id>
```

This allows you to easily set up an external monitoring tool, like [Uptime Robot](https://uptimerobot.com/).

```yml
# docker-compose.yml
stillonboard:
    image: mauvm/stillonboard:0.2
    container_name: stillonboard
    ports:
        - 8080:8080
    volumes:
        - /var/run/docker.sock:/var/run/docker.sock
    environment:
        ALLOW: 0
        ALLOW_STILLONBOARD: 1
        ALLOW_OTHER_CONTAINER: 1
```

## Configuration

Change the Docker port flag to whatever external port you want to use: `-p 1234:8080`.

Black- and whitelisting containers can be done with environment variables:

```bash
# Use ALLOW=0 for blacklisting all containers
docker run -d -p 8080:8080 \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-e ALLOW=0 -e ALLOW_STILLONBOARD=1 \
	-e ALLOW_MY_CONTAINER=1 \
	--name stillonboard mauvm/stillonboard:0.2

curl -v http://localhost:8080/my_container

# y, yes, true, 1 for whitelisting (case insensitive)
# n, no, false, 0 for blacklisting (case insensitive)
```

You can also use the [Docker `--env-file` flag](https://docs.docker.com/engine/reference/commandline/run/#set-environment-variables-e-env-env-file) for this.

## Debugging

```bash
make run
make test

docker exec -it stillonboard bash
echo -e "GET /containers/json HTTP/1.1\r\n" | socat unix-connect:/var/run/docker.sock STDIO
# Should output container info (JSON)

curl -v localhost:8080/stillonboard

docker logs stillonboard
```
