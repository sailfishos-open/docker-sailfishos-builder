FROM coderus/sailfishos-baseimage AS build

ARG SFOS_ARCH=i486
ARG RELEASE=4.6.0.13

RUN mkdir /app
WORKDIR /app

COPY ./scripts/setup-root /app
RUN chmod +x setup-root

RUN /app/setup-root $SFOS_ARCH $RELEASE

FROM scratch

COPY --from=build /sfos /
COPY \
    scripts/buildrpm  \
    scripts/rpm-install-build-deps \
    rpmdevtools/rpmdev-spectool \
    rpmdevtools/rpmdev-setuptree \
    /usr/bin

# rpm database rebuild: somehow doesn't work cleanly
RUN rm -f /var/lib/rpm/__db*
RUN \
    rpm --rebuilddb || \
    echo "For some reason it fails, ignore. It does rebuild anyway." \
    rm -rf /var/lib/rpmrebuilddb.* || \
    echo "Makes sense to remove if it failed above"

# install packages that have to be installed after base system is
# settled
RUN \
    zypper --non-interactive in \
    git

# skipping install of SSU - handle repositories via zypper
#
# # setup ssu - cannot be installed in setup-root due to gpg errors
# RUN zypper --non-interactive in ssu ssu-vendor-data-jolla
# RUN ssu re @RELEASE@

# clear zypper cache
RUN rm -rf /home/.zypp-cache

# install required dependencies
RUN pip3 install progressbar requests
RUN rm -rf /root/.cache

# create source location
RUN mkdir /source

# add user builder
RUN useradd -rm -d /builder -s /bin/bash builder

USER builder

RUN mkdir /builder/rpmbuild

WORKDIR /builder/rpmbuild

USER root
WORKDIR /builder

CMD ["/usr/bin/bash"]
