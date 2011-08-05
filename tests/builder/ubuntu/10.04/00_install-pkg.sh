#!/bin/sh
#
# Ubuntu 10.04 LTS
#

export LANG=C
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
export PATH=/bin:/usr/bin:/sbin:/usr/sbin

builder_path=${builder_path:?"builder_path needs to be set"}


# core packages
deb_pkgs="
 ebtables iptables ipset ethtool
 openssh-server openssh-client
 ruby ruby-dev libopenssl-ruby1.8
 rdoc1.8 irb1.8
 g++
 curl libcurl4-openssl-dev
 mysql-server mysql-client libmysqlclient16-dev
 rabbitmq-server
 qemu-kvm kvm-pxe iptables ebtables ubuntu-vm-builder
 dnsmasq
 open-iscsi open-iscsi-utils
 nginx
 libxml2-dev  libxslt1-dev
"
# apache2 apache2-threaded-dev libapache2-mod-passenger
# from natty
deb_pkgs="
 ${deb_pkgs}
 lxc/natty
 rubygems/natty
 rubygems1.8/natty
 tgt/natty
"

# host configuration
hostname | diff /etc/hostname - >/dev/null || hostname > /etc/hostname
egrep -v '^#' /etc/hosts | egrep -q $(hostname) || echo 127.0.0.1 $(hostname) >> /etc/hosts

#  some packages use ubuntu-natty. ex. lxc
cd ubuntu-natty && make

# debian packages
DEBIAN_FRONTEND=${DEBIAN_FRONTEND} apt-get update
DEBIAN_FRONTEND=${DEBIAN_FRONTEND} apt-get -y upgrade
DEBIAN_FRONTEND=${DEBIAN_FRONTEND} apt-get -y install ${deb_pkgs}

exit 0
