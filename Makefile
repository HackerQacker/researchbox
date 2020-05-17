IMAGE_NAME=omerye/researchbox

all: build-docker

no-cache: RB_BUILD_ARGS+=--no-cache
no-cache: build-docker

build-docker:
	docker build ${RB_BUILD_ARGS} --pull -t ${IMAGE_NAME} .
