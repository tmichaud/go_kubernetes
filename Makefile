APP?=app
PORT?=8080
PROJECT?=github.com/go_kubernetes
RELEASE?=$(shell git describe --abbrev=0 --tags)
COMMIT?=$(shell git rev-parse --short HEAD)
BUILD_TIME?=$(shell date -u '+%Y-%m-%d_%H:%M:%S')

clean:
		rm -rf ${APP}

build: clean
	go build \
		-ldflags "-s -w \
		-X ${PROJECT}/version.Release=${RELEASE} \
		-X ${PROJECT}/version.Commit=${COMMIT} \
		-X ${PROJECT}/version.BuildTime=${BUILD_TIME} " \
	        -o ${APP}

run: build
	PORT=${PORT} ./${APP}

test:
	go test -v -race ./...
