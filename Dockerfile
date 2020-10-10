FROM ubuntu:20.04
RUN dpkg --add-architecture i386
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y sudo git dialog lsb-release binutils wget ca-certificates device-tree-compiler \
	pv bc lzop zip binfmt-support build-essential ccache debootstrap ntpdate gawk gcc-arm-linux-gnueabihf gcc-8-arm-linux-gnueabihf \
	qemu-user-static u-boot-tools uuid-dev zlib1g-dev unzip libusb-1.0-0-dev parted pkg-config libncurses5-dev whiptail debian-keyring \
	debian-archive-keyring f2fs-tools libfile-fcntllock-perl rsync libssl-dev nfs-kernel-server btrfs-progs ncurses-term p7zip-full kmod \
	dosfstools libc6-dev-armhf-cross fakeroot curl patchutils python2 python3 liblz4-tool libpython2.7-dev linux-base swig aptly acl \
	systemd-container udev g++-10-arm-linux-gnueabihf lib32stdc++6 libc6-i386 lib32ncurses6 lib32tinfo6 locales ncurses-base zlib1g:i386 \
	pixz bison libbison-dev flex libfl-dev lib32z1 tzdata cpio libglib2.0-dev libtool gettext
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8' TERM=screen

# Switch to normal user
RUN useradd -c 'khadas' -m -d /home/khadas -s /bin/bash khadas
RUN sed -i -e '/\%sudo/ c \%sudo ALL=(ALL) NOPASSWD: ALL' /etc/sudoers
RUN usermod -a -G sudo khadas

# Add toolchains
ADD toolchains/gcc-linaro-aarch64-elf /home/khadas/toolchains/gcc-linaro-aarch64-elf
ADD toolchains/gcc-linaro-aarch64-linux-gnu /home/khadas/toolchains/gcc-linaro-aarch64-linux-gnu
ADD toolchains/gcc-linaro-aarch64-none-elf /home/khadas/toolchains/gcc-linaro-aarch64-none-elf
ADD toolchains/gcc-linaro-arm-none-eabi /home/khadas/toolchains/gcc-linaro-arm-none-eabi
ADD toolchains/gcc-arm-aarch64-none-linux-gnu /home/khadas/toolchains/gcc-arm-aarch64-none-linux-gnu


USER khadas

WORKDIR /home/khadas/fenix
ENTRYPOINT [ "/bin/bash" ]
