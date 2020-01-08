#!/bin/bash

RB_SHARED=${RB_SHARED:-$HOME/ctfs}
IMAGE=omerye/researchbox
TAG=latest
NAME=ctf
CONTAINER_OPTS=''

show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-t TAG] [-p RB_SHARED] [-n NAME]
Run researchbox container and mount a local shared data path.

    -h            Display this help and exit
    -t DOCKERTAG  Set researchbox's docker tag (default: "${TAG}")
    -m RB_SHARED  Local path to mount to (default: "${RB_SHARED}") (override default value by setting RB_SHARED env var)
    -n NAME       Set the container name (default: "${NAME}")
    -p            Publish docker exposed ports
EOF
}

while getopts ht:m:n:p opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        t) TAG=$OPTARG
            ;;
        m) RB_SHARED=$OPTARG
            ;;
        n) NAME=$OPTARG
            ;;
        p)
            CONTAINER_OPTS+="-p 127.0.0.1:8080:8080 -p 127.0.0.1:1337:1337 -p 127.0.0.1:3002:3002 -p 127.0.0.1:3003:3003 -p 120.0.0.1:4000:4000"
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done

docker run --rm --privileged --net=host -it --name ${NAME} -v ${RB_SHARED}:/home/re/shared ${CONTAINER_OPTS} ${IMAGE}:${TAG}
