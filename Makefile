.POSIX:
.PHONY: *
.EXPORT_ALL_VARIABLES:

default: build

build:
	docker build -t xmconstantx/configurable-bananode:stable .

push:
	docker push xmconstantx/configurable-bananode:stable