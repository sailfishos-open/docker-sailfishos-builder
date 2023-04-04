FROM scratch
ADD baseimage.tar /

# ssu release
RUN ssu re @RELEASE@

# add user
RUN useradd -rm -d /builder -s /bin/bash builder

USER builder

RUN mkdir /builder/rpmbuild

WORKDIR /builder/rpmbuild

#RUN mkdir BUILD RPMS SOURCES SPECS SRPMS

USER root
WORKDIR /builder

CMD ["/usr/bin/bash"]
