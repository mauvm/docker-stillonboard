# Still On Board

> Ultra lightweight Docker status reporter (~9.2MB for full image).

A Bash webserver that inspects a Docker container (by given name) to check if it's still running.

## How to use

```bash
docker run -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock --name stillonboard mauvm/stillonboard
curl -v localhost:8080/stillonboard          # 200 OK
curl -v localhost:8080/nonExistingContainer  # 503 Service Unavailable
# curl -v localhost:8080/<container name or id>
```

This allows you to easily set up an external monitoring tool, like [Uptime Robot](https://uptimerobot.com/).

## Debugging

```bash
make run
make test

docker exec -it stillonboard bash
echo -e "GET /containers/json HTTP/1.1\r\n" | socat unix-connect:/var/run/docker.sock STDIO
# Should output container info (JSON)

curl -v localhost:8080/stillonboard
```
