REGISTRY ?= docker.seibert-media.net
IMAGE    ?= seibertmedia/erpnext
VERSION  ?= latest
VERSIONS = $(VERSION)

VERSIONS += $(shell git fetch --tags; git tag -l --points-at HEAD)

default: build

all: build upload clean

build:
	@tags=""; \
	for i in $(VERSIONS); do \
		tags="$$tags -t $(REGISTRY)/$(IMAGE):$$i"; \
	done; \
	docker build --no-cache --rm=true --build-arg VERSION=$(VENDOR_VERSION) $$tags .

clean:
	@for i in $(VERSIONS); do \
		docker rmi $(REGISTRY)/$(IMAGE):$$i || true; \
	done

upload:
	@for i in $(VERSIONS); do \
		docker push $(REGISTRY)/$(IMAGE):$$i; \
	done

versions:
	@for i in $(VERSIONS); do echo $$i; done;

open:
	open http://locahost:8000
