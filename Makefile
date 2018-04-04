ifeq ($(TARGET),rhel)
	ifndef DOCKER_REGISTRY
		$(error DOCKER_REGISTRY is not set)
	endif

	DOCKER_IMAGE_URL := $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_TARGET)
	REGISTRY := $(DOCKER_REGISTRY)
	DOCKERFILE := Dockerfile.rhel
else
	REGISTRY ?= registry.devshift.net
	DOCKERFILE := Dockerfile
endif

REPOSITORY?=fabric8-analytics/f8a-firehose-fetcher
DEFAULT_TAG=latest

.PHONY: all docker-build fast-docker-build test get-image-name get-image-repository

all: fast-docker-build

docker-build:
	docker build --no-cache -f $(DOCKERFILE) -t $(REGISTRY)/$(REPOSITORY):$(DEFAULT_TAG) .

fast-docker-build:
	docker build -f $(DOCKERFILE) -t $(REGISTRY)/$(REPOSITORY):$(DEFAULT_TAG) .

test: fast-docker-build
	./runtest.sh

get-image-name:
	@echo $(REGISTRY)/$(REPOSITORY):$(DEFAULT_TAG)

get-image-repository:
	@echo $(REPOSITORY)
