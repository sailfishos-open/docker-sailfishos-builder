FROM scratch
ADD baseimage.tar /

# copy tools
COPY \
    scripts/buildrpm \
    scripts/rpm-install-build-deps \
    rpmdevtools/rpmdev-spectool \
    rpmdevtools/rpmdev-setuptree \
    /usr/bin/

# ssu release
RUN ssu re @RELEASE@

# install required dependencies
RUN pip3 install progressbar requests

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
