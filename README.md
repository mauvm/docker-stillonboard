# Still On Board

> Ultra lightweight Docker monitor (~31MB for full image).

A Bash webserver that inspects a Docker container (by given name) to check if it's still running.

## How to use

```
docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock --name stillonboard mauvm/stillonboard
curl localhost:9000/stillonboard # 200 OK
curl localhost:9000/mysql        # 503 Service Unavailable
# curl localhost:9000/<container name or id>
```

This allows you to easily set up an external monitoring tool, like [Uptime Robot](https://uptimerobot.com/).

## To do

- [ ] Add support for whitelisting container names
