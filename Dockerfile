# build container
FROM opensuse/leap:15.5 AS build

ARG SFOS_ARCH=i486
ARG RELEASE=4.6.0.13

RUN mkdir /app
WORKDIR /app

COPY ./scripts/setup-root /app

RUN /app/setup-root $SFOS_ARCH $RELEASE

# run container
FROM scratch

COPY --from=build /sfos /

# drop rpm databases
RUN rm -f /var/lib/rpm/__db*
RUN rpm --rebuilddb || \
    rm -rf /var/lib/rpmrebuilddb.* || \
    echo "Usually the rebuild fails, ignore it"

# install the base system again to register it with rpm
RUN zypper --gpg-auto-import-keys --non-interactive in \
    atruncate \
    attr \
    basesystem \
    busybox-symlinks-coreutils \
    gnu-bash \
    gnu-diffutils \
    gnu-findutils \
    gnu-grep \
    gnu-gzip \
    gnu-sed \
    gnu-tar \
    gnu-which \
    deltarpm \
    file \
    jolla-ca \
    kbd \
    meego-rpm-config \
    net-tools \
    passwd \
    pigz \
    procps-ng \
    psmisc-tools \
    rootfiles \
    sailfish-ca \
    shadow-utils \
    util-linux \
    xdg-utils \
    zypper

# install developer packages: required
RUN zypper --non-interactive in \
    createrepo_c \
    git \
    make \
    python3-pip \
    rpmlint \
    rpm-build

## install developer packages: extras
RUN zypper --non-interactive in \
    gcc-c++

# clear zypper cache
RUN rm -rf /home/.zypp-cache

# drop lastlog - Docker will just waste storage on it
RUN rm -f $INSTALL_ROOT/var/log/lastlog

# install required dependencies
RUN pip3 install progressbar requests
RUN rm -rf /root/.cache

# copy scripts
COPY \
    scripts/buildrpm  \
    scripts/clone-git  \
    scripts/rpm-install-build-deps \
    rpmdevtools/rpmdev-spectool \
    rpmdevtools/rpmdev-setuptree \
    /usr/bin

# set locale
RUN echo LANG="en_US.utf8" > /etc/locale.conf

# create source location
RUN mkdir /source

# add user builder
RUN useradd -rm -d /builder -s /bin/bash builder

USER builder

RUN mkdir /builder/rpmbuild

WORKDIR /builder/rpmbuild

USER root
WORKDIR /builder

LABEL org.opencontainers.image.source="https://github.com/sailfishos-open/docker-sailfishos-builder"

CMD ["/usr/bin/bash"]
