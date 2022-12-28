.POSIX:
.PHONY: *
.EXPORT_ALL_VARIABLES:

default: build

build:
	docker build -t xmconstantx/configurable-bananode .

push:
	docker push xmconstantx/configurable-bananode