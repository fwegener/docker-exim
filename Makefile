## For more examples of a Makefile based Docker container deployment see: https://github.com/ypid/docker-makefile

DOCKER_RUN_OPTIONS ?= --env "TZ=Europe/Berlin"

docker_exim_permanent_storage ?= /data/docker/mail-data
docker_exim_ssl_cert ?= /data/docker/etc/ssl/gwy2.pem
docker_exim_ssl_key  ?= /data/docker/etc/ssl/gwy2.key
docker_exim_servername ?= exim
image_exim ?= fwegener/exim

.PHONY: default start stop run build build-dev exim exim-dev rm-containers

default:
	@echo 'See Makefile and README.md'

start:
	docker start exim

stop:
	docker stop exim

run: exim

rm-containers:
	docker rm --force exim

build:
	docker build --no-cache=true --tag $(image_exim) .

build-dev:
	docker build --no-cache=false --tag $(image_exim) .

exim:
	-@docker rm --force "$@"
	docker run --detach \
		--name "$@" \
		$(DOCKER_RUN_OPTIONS) \
		--volume "$(docker_exim_permanent_storage)/data:/var/mail" \
		--volume "$(docker_exim_permanent_storage)/log:/var/log/exim4" \
		--volume "$(docker_exim_permanent_storage)/config:/exim4" \
		--volume "$(docker_exim_ssl_cert):/etc/ssl/certs/ssl-mail.pem:ro" \
		--volume "$(docker_exim_ssl_key):/etc/ssl/private/ssl-mail.key:ro" \
		--publish 25:25 \
		$(image_exim)
