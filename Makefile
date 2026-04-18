SHELL := /usr/bin/env bash

.PHONY: lock check build test hashes

lock:
	nix flake lock

check:
	nix flake check

build:
	nix build .#ocm-backplane

test:
	./scripts/test-package.sh

hashes:
	@if [ -z "$(VERSION)" ]; then \
		echo "Usage: make hashes VERSION=v0.8.0"; \
		exit 1; \
	fi
	./scripts/compute-hashes.sh $(VERSION)
