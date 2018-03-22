# Introduction

Endlessly pulling the same docker images when doing automated testing,
particularly in emphemeral VMs, can be sped up using a [pull-through
docker registry](https://docs.docker.com/registry/recipes/mirror/).

This repository just adds a little automation to the existing
instructions.

## Install

	git clone https://github.com/frobware/docker-registry-mirror
	cd docker-registry-mirror

	# generate self-signed certificates
	make

	# run the docker registry image with our certificates
	make run

## Configuring docker to use this new pull-through registry

You need to update docker's configuration to specify that it should
use this local registry mirror. Using fedora as an example:

### Add the registry mirror endpoint to /etc/sysconfig/docker

	OPTIONS='--selinux-enabled --log-driver=journald --registry-mirror=https://spicy.internal.frobware.com:5000'

### And also tell docker that it's OK to trust it:

	INSECURE_REGISTRY='--insecure-registry spicy.internal.frobware.com:5000'

I use a FQDN here because I refer to this endpoint/mirror in other VMs
that are running docker on my local LAN.

### Restart docker:

	systemctl restart docker

## Testing

The first time an image is pulled it will contact the registry mirror,
find out it doesn't have that image, then pull in the normal way. The
second time, however, should be a lot quicker as it will come from
your local mirror.

	docker pull fedora

	docker rmi fedora
	docker pull fedora
