default: build

# Build Docker image
build: docker_build output

# Build and push Docker image
release: docker_build docker_push output

# Build, push, and deploy Docker image
deploy: docker_build docker_push docker_deploy output

# Read .env file
$(shell touch .env)
include .env
export $(shell sed 's/=.*//' .env)

# Stack name can be overidden with env var.
DOCKER_STACK ?= traefik

# Image name can be overidden with env var.
DOCKER_IMAGE ?= docker-hub-user/$(DOCKER_STACK)
export DOCKER_IMAGE

# Domain name can be overidden with env var.
DOCKER_DOMAIN ?= example.com
export DOCKER_DOMAIN

# Acme email can be overidden with env var.
ACME_EMAIL ?= test@example.com
export ACME_EMAIL

# Get the latest commit.
GIT_COMMIT = $(strip $(shell git rev-parse --short HEAD))

# Get the version number from the code
CODE_VERSION = $(strip $(shell cat VERSION))

# Find out if the working directory is clean
GIT_NOT_CLEAN_CHECK = $(shell git status --porcelain)
ifneq (x$(GIT_NOT_CLEAN_CHECK), x)
DOCKER_TAG_SUFFIX = -dirty
endif

# If we're releasing to Docker Hub, and we're going to mark it with the latest tag, it should exactly match a version release
ifeq ($(MAKECMDGOALS),release)
# Use the version number as the release tag.
DOCKER_TAG = $(CODE_VERSION)

ifndef CODE_VERSION
$(error You need to create a VERSION file to build a release)
endif

# See what commit is tagged to match the version
VERSION_COMMIT = $(strip $(shell git rev-list $(CODE_VERSION) -n 1 | cut -c1-7))
ifneq ($(VERSION_COMMIT), $(GIT_COMMIT))
$(error echo You are trying to push a build based on commit $(GIT_COMMIT) but the tagged release version is $(VERSION_COMMIT))
endif

# Don't push to Docker Hub if this isn't a clean repo
ifneq (x$(GIT_NOT_CLEAN_CHECK), x)
$(error echo You are trying to release a build based on a dirty repo)
endif

else
# Add the commit ref for development builds. Mark as dirty if the working directory isn't clean
DOCKER_TAG = $(CODE_VERSION)-$(GIT_COMMIT)$(DOCKER_TAG_SUFFIX)
endif
export DOCKER_TAG

SOURCES := $(shell find . -name '*.go')

docker_build:
	# Build Docker image
	docker build \
  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
  --build-arg VERSION=$(CODE_VERSION) \
  --build-arg VCS_URL=`git config --get remote.origin.url` \
  --build-arg VCS_REF=$(GIT_COMMIT) \
	-t $(DOCKER_IMAGE):$(DOCKER_TAG) .

docker_push:
	# Tag image as latest
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_IMAGE):latest

	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
	docker push $(DOCKER_IMAGE):latest

docker_deploy:
	docker stack deploy --compose-file docker-compose.yml $(DOCKER_STACK)

printenv:
	printenv

output:
	@echo Docker Image: $(DOCKER_IMAGE):$(DOCKER_TAG)
