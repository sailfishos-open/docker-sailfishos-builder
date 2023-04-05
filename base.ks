lang en_US.UTF-8
keyboard us
timezone --utc UTC

part / --size 500 --ondisk sda --fstype=ext4

repo --name=adaptation-common --baseurl=https://releases.jolla.com/releases/@RELEASE@/jolla-hw/adaptation-common/@ARCH@/
repo --name=apps --baseurl=https://releases.jolla.com/jolla-apps/@RELEASE@/@ARCH@/
repo --name=hotfixes --baseurl=https://releases.jolla.com/releases/@RELEASE@/hotfixes/@ARCH@/
repo --name=jolla --baseurl=https://releases.jolla.com/releases/@RELEASE@/jolla/@ARCH@/

%packages
atruncate
attr
basesystem
gnu-bash
gnu-coreutils
gnu-cpio
gnu-diffutils
gnu-findutils
gnu-grep
gnu-gzip
gnu-sed
gnu-tar
gnu-which
deltarpm
file
kbd
meego-rpm-config
net-tools
passwd
pigz
procps-ng
psmisc-tools
python3-pip
rootfiles
rpm-build
rpmlint
ssu
ssu-vendor-data-jolla
zypper
%end

%pre
touch $INSTALL_ROOT/.bootstrap
%end

%post
echo -n "@ARCH@-meego-linux" > /etc/rpm/platform
echo "arch = @ARCH@" >> /etc/zypp/zypp.conf
rm -f /var/lib/rpm/__db*
rpm --rebuilddb
rm -f /.bootstrap

# cleanup
rm -f /var/log/lastlog

%end

%post --nochroot
if [ -n "$IMG_NAME" ]; then
    echo "BUILD: $IMG_NAME" >> $INSTALL_ROOT/etc/meego-release
fi
%end
