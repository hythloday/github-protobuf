.PHONY: default
.DEFAULT_GOAL := test

VERSION := 1.0.2
NAME := github-protobuf
PKG := jhaynie/$(NAME)

SHELL := /bin/bash
BASEDIR := $(shell echo $${PWD})

default: all test;

clean:
	@rm -rf build

protoc-go:
	@mkdir -p build/$(VERSION)/go
	@cp $(BASEDIR)/src/*.proto build/$(VERSION)/go
	@docker run --rm -v $(BASEDIR):/app -w /app znly/protoc --gofast_out=build/$(VERSION)/go --proto_path=/app/vendor/:src src/*.proto

protoc-python:
	@mkdir -p build/$(VERSION)/python
	@cp $(BASEDIR)/src/*.proto build/$(VERSION)/python
	@docker run --rm -v $(BASEDIR):/app -w /app znly/protoc --python_out=build/$(VERSION)/python --proto_path=/app/vendor/:src src/*.proto

protoc-java:
	@mkdir -p build/$(VERSION)/java
	@cp $(BASEDIR)/src/*.proto build/$(VERSION)/java
	@docker run --rm -v $(BASEDIR):/app -w /app znly/protoc --java_out=build/$(VERSION)/java --proto_path=/app/vendor/:src src/*.proto

protoc-js:
	@mkdir -p build/$(VERSION)/javascript
	@cp $(BASEDIR)/src/*.proto build/$(VERSION)/javascript
	@docker run --rm -v $(BASEDIR):/app -w /app znly/protoc --js_out=build/$(VERSION)/javascript --proto_path=/app/vendor/:src src/*.proto

protoc-ruby:
	@mkdir -p build/$(VERSION)/ruby
	@cp $(BASEDIR)/src/*.proto build/$(VERSION)/ruby
	@docker run --rm -v $(BASEDIR):/app -w /app znly/protoc --ruby_out=build/$(VERSION)/ruby --proto_path=/app/vendor/:src src/*.proto

protoc-php:
	@mkdir -p build/$(VERSION)/php
	@cp $(BASEDIR)/src/*.proto build/$(VERSION)/php
	@docker run --rm -v $(BASEDIR):/app -w /app znly/protoc --php_out=build/$(VERSION)/php --proto_path=/app/vendor/:src src/*.proto

test: protoc-go
	@cp test/* build/$(VERSION)/go
	@cd build/$(VERSION)/go && go test -v *.pb.go *_test.go

all: protoc-go protoc-python protoc-java protoc-js protoc-ruby protoc-php

release: clean test clean all
	@cd build && rm -rf *.tar *.gz && tar cvf $(NAME)-$(VERSION).tar --exclude=*_test* * && gzip *.tar

default: all
