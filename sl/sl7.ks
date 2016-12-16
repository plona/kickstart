#version=DEVEL
# Standart options
install
cmdline
poweroff
timezone Europe/Warsaw --isUtc --ntpservers=2.rhel.pool.ntp.org,3.rhel.pool.ntp.org,0.rhel.pool.ntp.org,1.rhel.pool.ntp.org

# Repo
# Use network installation
url --url=$tree
$yum_repo_stanza

# Use text mode install
text

firstboot --disable
# firstboot --enable
# firewall --disable

# Language
lang pl_PL.UTF-8
keyboard pl2

# Network
# network --onboot yes --device eth1 --bootproto static --noipv6 --ip=10.243.255.85 --netmask=255.255.255.0 --gateway=10.243.255.1 --nameserver=172.19.243.1
# network --onboot yes --device eth0 --bootproto static --noipv6 --ip=172.19.243.85 --netmask=255.255.255.0 --hostname=pyongyang.dro.nask.pl

# User
rootpw  --iscrypted 

# Security
authconfig --enableshadow --passalgo=sha512
selinux --disabled

# System services
services --enabled="chronyd"

# Disks
zerombr
bootloader --location=mbr --boot-drive=vda --append="crashkernel=0 rhgb ipv6.disable=1 modprobe.blacklist=floppy,sr_mod,cdrom,ppdev,parport_pc,parport,pcspkr,serio_raw"
clearpart --all --drives=vda,vdb
# vda
part /boot --fstype=ext4 --ondisk=vda --size=512
part pv.01 --fstype=lvmpv --ondisk=vda --grow --size=1024
volgroup vg01 --pesize=4096 pv.01
logvol / --fstype=ext4 --name=sys --vgname=vg01 --grow --size=1024
# vdb
part swap --fstype=swap --ondisk=vdb --grow --size=1

%packages
@core
@security-tools
iptables
iptables-services
net-tools
bind-utils
ntp
ntpdate
tcpdump
nmap-ncat
sysstat
htop
openssh-clients
wget
telnet
tmux
mc
unzip
vim-enhanced
bash-completion
yum-utils
mlocate
mailx
ovirt-guest-agent-common

%end

%post
$SNIPPET('log_ks_post')
$SNIPPET('post_install_network_config')

yum remove -y iwl*-firmware ivtv-firmware aic94xx-firmware
yum remove -y alsa-firmware alsa-lib alsa-tools-firmware
yum remove -y NetworkManager NetworkManager-*
yum remove -y yum-cron dnsmasq firewalld
yum remove -y kernel-tools*
yum remove -y ppp wpa_supplicant

# ---------------------------------------
# pliki konfiguracyjne  + dotfiles root-a
# ---------------------------------------

# ntp 
systemctl enable ntpdate ntpd
cd /etc && {
    mv ntp.conf ntp.conf.orig
    wget http://172.19.243.5/cobbler/files/rhel7/ntp.conf
}

# iptables
systemctl enable iptables
cd /etc/sysconfig && {
    mv iptables iptables.orig
    wget http://172.19.243.5/cobbler/files/iptables
    chmod 600 iptables
}

# tmux
cd /etc && wget http://172.19.243.5/cobbler/files/tmux.conf
cd /usr/bin
[[ -x tmux ]] && ln -s tmux t

# vim
cd /usr/share/vim/vimfiles/spell && wget http://172.19.243.5/cobbler/files/pl.utf-8.spl
cd /tmp && {
    rm -rf bash-support-master/
    wget http://172.19.243.5/cobbler/files/bash-support-master.zip
    unzip bash-support-master.zip
    pushd bash-support-master && {
        [[ -d /usr/share/vim/vimfiles ]] && find . -print | cpio -pd /usr/share/vim/vimfiles
    }
    popd
    rm bash-support-master.zip
    rm -rf bash-support-master
}

# modules
cd /etc/modprobe.d && wget http://172.19.243.5/cobbler/files/noload.conf

# yum
cd /etc && {
    cp -Rp yum.repos.d yum.repos.d.orig
    cd yum.repos.d && {
        rm -rf *
        wget -r --no-directories --no-parent -A '*.repo' http://172.19.243.5/cobbler/files/rhel7/yum.repos.d/
    }
}
cd /etc/pki/rpm-gpg && {
    wget -r -nc --no-directories --no-parent -A '*GPG-KEY*' http://172.19.243.5/cobbler/files/rhel7/rpm-gpg/
    for key in * ; do
        echo $key
        rpm --import $key
    done
}
yum clean all
yum makecache fast

# root - dla wygody
cd /root && {
    mkdir .config
    chmod 700 .config
    pushd .config && {
        wget http://172.19.243.5/cobbler/files/mc.tar.gz
        gzip -dc mc.tar.gz | tar xvf -
        rm mc.tar.gz
        popd
    }
    wget http://172.19.243.5/cobbler/files/.bash_profile.template
    wget http://172.19.243.5/cobbler/files/.bashrc.template
    wget http://172.19.243.5/cobbler/files/.vimrc
    wget http://172.19.243.5/cobbler/files/.vim.tar.gz
    cat .bashrc.template >> .bashrc
    cat .bash_profile.template >> .bash_profile
    gzip -dc .vim.tar.gz | tar xvf -
    rm .bash_profile.template .bashrc.template .vim.tar.gz
}

%end

