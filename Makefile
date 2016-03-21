ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BIN_DIR = $(ROOT_DIR)/bin
FILE_NAME := $(shell basename $(CURDIR))

default: build

build: clean check fast strip
	@(echo "-> Binary created & clean")

fast:
	@(echo "-> Compiling binary")
	go build -o $(BIN_DIR)/$(FILE_NAME) main.go

strip:
	@(echo "-> Cleaning binary")
	strip $(BIN_DIR)/$(FILE_NAME)

clean:
	@(echo "-> Cleaning file")
	rm -f $(BIN_DIR)/*

check:
	@(echo "-> Preparing code")
	go fmt ./...
	go vet ./...
	golint ./...
	errcheck ./...
	varcheck ./...
	structcheck ./...
	aligncheck ./...
	deadcode .
	ineffassign .
	go tool vet --shadow ./*.go
#	gometalinter ./...

init:
	@(echo "-> Init")
	@(mkdir -p $(BIN_DIR))
	@(printf '%s\n%s\n' '*' '!.gitignore' >> $(BIN_DIR)/.gitignore)

run: check
	@(echo "-> Runing app")
	go run main.go