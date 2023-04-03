#!/bin/bash

DOCKER_PLATFORM_ARCH=amd64 #arm64v8
SFOS_ARCH=i486
RELEASE=4.5.0.19

set -e

rm -f baseimage.tar
cp base.ks base_${SFOS_ARCH}_${RELEASE}.ks
docker run --rm --privileged --network=host -v $(pwd):/share -w /share coderus/sailfishos-baseimage \
       mic create fs -v -d --arch=$SFOS_ARCH --outdir=/share --tokenmap=ARCH:${SFOS_ARCH},RELEASE:$RELEASE \
       --pack-to=baseimage.tar base_${SFOS_ARCH}_${RELEASE}.ks

# older docker import ignores platform
# added in https://github.com/moby/moby/pull/43103
echo -e 'FROM scratch\nADD baseimage.tar /\nCMD ["/usr/bin/bash"]' | \
    docker build -t sailfishos-${SFOS_ARCH}-${RELEASE} --platform=linux/$DOCKER_PLATFORM_ARCH -f- .

# older docker import ignores platform
# docker import --platform linux/$DOCKER_PLATFORM_ARCH baseimage.tar sailfishos-$SFOS_ARCH-$RELEASE
