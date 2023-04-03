FROM scratch
ADD baseimage.tar /

# add user
RUN useradd -rm -d /home/builder -s /bin/bash builder

USER builder

WORKDIR /home/builder

CMD ["/usr/bin/bash"]