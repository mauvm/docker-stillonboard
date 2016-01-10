default: build

build: Dockerfile serve.sh
	docker build -t stillonboard .

run: build
	docker run --rm -it -p 8080:8080 \
		-v /var/run/docker.sock:/var/run/docker.sock \
		--name stillonboard stillonboard

test:
	@curl -v http://localhost:8080/stillonboard
	@curl -v http://localhost:8080/nonexistingservice
