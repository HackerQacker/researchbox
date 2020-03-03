IMAGE_NAME=omerye/researchbox

all: build-docker

build-docker:
	docker build -t ${IMAGE_NAME} .
