FROM scratch
ADD / /

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
