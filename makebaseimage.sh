#!/bin/bash

set -e

usage="$(basename "$0") [-h] ARCH REL

where:
    -h    show this help text
    ARCH  Sailfish OS arch
    REL   Sailfish OS release
"

if [ "$1" == "-h" ]; then
    echo "$usage"
    exit 0
fi

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
    echo
    echo "$usage"
    exit 1
fi

SFOS_ARCH=$1
RELEASE=$2

case "$SFOS_ARCH" in
    "i486")
	DOCKER_PLATFORM_ARCH=i386
	;;
    "aarch64")
	DOCKER_PLATFORM_ARCH=arm64v8
	;;
    "armv7hl")
	DOCKER_PLATFORM_ARCH=arm32v7
	;;
    *)
	echo "Unknown architecture specified:" "$SFOS_ARCH"
	exit -1
esac

rm -f baseimage.tar
cp base.ks base_${SFOS_ARCH}_${RELEASE}.ks
docker run --rm --privileged --network=host -v $(pwd):/share -w /share coderus/sailfishos-baseimage \
       mic create fs -v -d --arch=$SFOS_ARCH --outdir=/share --tokenmap=ARCH:${SFOS_ARCH},RELEASE:$RELEASE \
       --pack-to=baseimage.tar base_${SFOS_ARCH}_${RELEASE}.ks

# older docker import ignores platform
# added in https://github.com/moby/moby/pull/43103

cat Dockerfile | sed -e "s/@RELEASE@/$RELEASE/g" | \
    docker build -t sailfishos-${SFOS_ARCH}-${RELEASE} --platform=linux/$DOCKER_PLATFORM_ARCH -f- .
