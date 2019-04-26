APP?=app
PORT?=8080
RELEASE?=0.0.1
COMMIT?=$(shell git rev-parse --short HEAD)
BUILD_TIME?=$(shell date -u '+%Y-%m-%d_%H:%M:%S')

clean:
		rm -rf ${APP}

build: clean
	go build -o ${APP}

run: build
	PORT=${PORT} ./${APP}

test:
	go test -v -race ./...
