ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BIN_DIR = $(ROOT_DIR)/bin
FILE_NAME := $(shell basename $(CURDIR))

default: build

build: clean check fast
	@(echo "-> Binary created")

fast:
	@(echo "-> Compiling binary")
	go build -ldflags "-s" -o $(BIN_DIR)/$(FILE_NAME) main.go

clean:
	@(echo "-> Cleaning file")
	rm -f $(BIN_DIR)/*

fmt:
	@(echo "-> Preparing code")
	go fmt ./...
	gofmt -w -s .

check: fmt
	@(echo "-> Cheking code")
	go vet ./...
	golint ./...
	errcheck ./...
	varcheck ./...
	structcheck ./...
	aligncheck ./...
	deadcode .
	ineffassign .
	go tool vet --shadow .
	dupl -plumbing -t 50 .
	depscheck .
	gosimple ./...
	interfacer ./...
	staticcheck ./...
#	gometalinter ./...

init:
	@(echo "-> Init")
	@(mkdir -p $(BIN_DIR))
	@(printf '%s\n%s\n' '*' '!.gitignore' >> $(BIN_DIR)/.gitignore)

run: check
	@(echo "-> Runing app")
	go run main.go