APP?=kapp
PORT?=8080
PROJECT?=go_kubernetes
RELEASE?=$(shell git describe --abbrev=0 --tags)
COMMIT?=$(shell git rev-parse --short HEAD)
BUILD_TIME?=$(shell date -u '+%Y-%m-%d_%H:%M:%S')
GOOS?=linux
GOARCH?=amd64
CONTAINER_IMAGE?=docker.io/tmichaud/$(APP)

clean:
		rm -rf ${APP}

build: clean
	CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} go build \
		-ldflags "-s -w \
		-X ${PROJECT}/version.Release=${RELEASE} \
		-X ${PROJECT}/version.Commit=${COMMIT} \
		-X ${PROJECT}/version.BuildTime=${BUILD_TIME} " \
	        -o ${APP}


container: build
	docker rmi $(APP):$(RELEASE) || true
	docker build -t tmichaud/$(APP):$(RELEASE) . 

push: container
	docker push $(CONTAINER_IMAGE):$(RELEASE)

run: container
	docker stop $(APP):$(RELEASE) || true && docker rm $(APP):$(RELEASE) || true
	docker run --name ${APP} -p ${PORT}:${PORT} --rm -e "PORT=${PORT}" $(APP):$(RELEASE)
	#PORT=${PORT} ./${APP}

test:
	go test -v -race ./...
