.POSIX:
.PHONY: *
.EXPORT_ALL_VARIABLES:

default: build

build:
	docker build .