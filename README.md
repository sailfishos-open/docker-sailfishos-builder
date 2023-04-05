# Experiments with Sailfish docker images

Testing on whether we can create docker images that can be used for
native building of packages. This is in contrast to building through
SDK.

Generation of build images is done through
coderus/sailfishos-baseimage and through its KS adopted for this case.

## QEMU setup

To enable QEMU in systemd based Linux, add `qemu-custom.conf` in
`/etc/binfmt.d`. Example:

```
:qemu-aarch64:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-aarch64:F
:qemu-arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm:F
```

After that, restart systemd service:
```
systemctl restart systemd-binfmt
```

You should see formats registered in `/proc`:
```
# cat /proc/sys/fs/binfmt_misc/qemu-aarch64
enabled
interpreter /usr/bin/qemu-aarch64
flags: F
offset 0
magic 7f454c460201010000000000000000000200b700
mask ffffffffffffff00fffffffffffffffffeffffff
```


## References

- SFOS Docker scripts: https://github.com/CODeRUS/docker-sailfishos-baseimage
- Docker architectures: https://github.com/docker-library/official-images#architectures-other-than-amd64
- QEMU setup: https://wiki.gentoo.org/wiki/Embedded_Handbook/General/Compiling_with_qemu_user_chroot