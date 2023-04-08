FROM scratch
ADD / /

# rpm database rebuild: somehow doesn't work
#RUN rm -f /var/lib/rpm/__db*
#RUN rpm --rebuilddb || echo "For some reason it fails, ignore"

# skipping install of SSU - handle repositories via zypper
#
# # setup ssu - cannot be installed in setup-root due to gpg errors
# RUN zypper --non-interactive in ssu ssu-vendor-data-jolla
# RUN ssu re @RELEASE@

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
