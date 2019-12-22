#!/bin/bash

RB_SHARED=${RB_SHARED:-$HOME/ctfs}
IMAGE=omerye/researchbox
TAG=latest
NAME=ctf

show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-t TAG] [-p RB_SHARED] [-n NAME]
Run researchbox container and mount a local shared data path.

    -h            Display this help and exit
    -t DOCKERTAG  Set researchbox's docker tag (default: "${TAG}")
    -p RB_SHARED  Local path to mount to (default: "${RB_SHARED}") (override default value by setting RB_SHARED env var)
    -n NAME       Set the container name (default: "${NAME}")
EOF
}


while getopts htp: opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        t) TAG=$OPTARG
            ;;
        p) RB_SHARED=$OPTARG
            ;;
        n) NAME=$OPTARG
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done

docker run --rm --privileged --net=host -it --name ${NAME} -v ${RB_SHARED}:/home/re/shared ${IMAGE}:${TAG}
