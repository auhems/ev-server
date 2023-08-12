
export SHELL := /bin/bash

.PHONY: help start-server config

help:
	@echo -e "Usage: make [TARGET]...\nAvailable targets:" >&2
	@awk 'BEGIN {FS = ":.*?## "} /^[a-z0-9A-Z_-]+:.*?## / \
		{printf "\033[36m%-30s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST) >&2

start-server: ## start MongoDB server
	brew services restart mongodb/brew/mongodb-community@4.4

config: ## update MongoDB config
	sudo vi /usr/local/etc/mongod.conf

