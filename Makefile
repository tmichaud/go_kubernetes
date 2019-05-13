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
		rm -rf t.i.yaml
		rm -rf t.d.yaml

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

run: 
	docker stop $(APP):$(RELEASE) || true && docker rm $(APP):$(RELEASE) || true
	docker run --name ${APP} -p ${PORT}:${PORT} --rm -e "PORT=${PORT}" tmichaud/$(APP):$(RELEASE)
	#PORT=${PORT} ./${APP}

#minikube: push

#minikube: 
#	cat ingress.yaml | \
#	    sed -E "s/\{\{(\s*)\.Release(\s*)\}\}/$(RELEASE)/g" | \
#	    sed -E "s/\{\{(\s*)\.ServiceName(\s*)\}\}/$(APP)/g" ; \
#	  echo ---; \
#	done > t.i.yaml
#	cat t.i.yaml
#	kubectl apply -f t.i.yaml
#	cat deployment.yaml | \
#	    sed -E "s/\{\{(\s*)\.Release(\s*)\}\}/$(RELEASE)/g" | \
#	    sed -E "s/\{\{(\s*)\.ServiceName(\s*)\}\}/$(APP)/g" ; \
#	  echo ---; \
#	done > t.d.yaml
#	cat t.d.yaml
#	kubectl apply -f t.d.yaml
#
#minikube2:
#	for t in $(shell find ./kubernetes/advent -type f -name "*.yaml"); do \
#        cat $$t | \
#        	sed -E "s/\{\{(\s*)\.Release(\s*)\}\}/$(RELEASE)/g" | \
#        	sed -E "s/\{\{(\s*)\.ServiceName(\s*)\}\}/$(APP)/g"; \
#        echo ---; \
#    done > tmp.yaml
#	cat tmp.yaml
#	kubectl apply -f tmp.yaml

minikube3:
	kubectl apply -f t.d.yaml2 #--validate=false
	kubectl apply -f t.s.yaml2 #--validate=false
	kubectl apply -f t.i.yaml2 #--validate=false

test:
	go test -v -race ./...
