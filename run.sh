#!/bin/bash

CTFSPATH=${CTFSPATH:-$HOME/ctfs}
IMAGE=researchbox
TAG=latest
NAME=ctf

show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-t TAG] [-p CTFSPATH] [-n NAME]
Run researchbox container and mount a local CTFs data path.

    -h            Display this help and exit
    -t DOCKERTAG  Set docket tag (default: "${TAG}")
    -p CTFSPATH   Local path to mount to (default: "${CTFSPATH}") (override default value by setting CTFSPATH env var)
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
        p) CTFSPATH=$OPTARG
            ;;
        n) NAME=$OPTARG
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done

docker run --rm --privileged --net=host -it --name ${NAME} -v ${CTFSPATH}:/home/re/ctf ${IMAGE}:${TAG}
