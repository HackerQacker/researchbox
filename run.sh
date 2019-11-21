#!/bin/bash

IMAGE=researchbox
TAG=latest
CTFSPATH=${HOME}/ctfs
NAME=ctf

show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-t TAG] [ -p CTFSPATH]
Run researchbox container and mount a local CTFs data path.

    -h            display this help and exit.
    -t DOCKERTAG  set docket tag (default: ${TAG}).
    -p CTFSPATH   local path to mount to (default: ${CTFSPATH}).
    -n NAME       set the container name (default: ${NAME})
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
        p) CTFSPATH=$OPTARG
            ;;
        n) NAME=$OPTARG
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
done

docker run --rm --privileged --net=host -it --name ${NAME} -v ${CTFSPATH}:/home/re/ctf ${IMAGE}:${TAG}
