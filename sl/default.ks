#version=DEVEL
# Standart options
install
cmdline
reboot
timezone --utc Europe/Warsaw

# Repo
# Use network installation
url --url=$tree
$yum_repo_stanza

# Language
lang en_US.UTF-8
keyboard us

# User
rootpw  --iscrypted $6$bojXVuBc/uCQN775$ZxCvGCUN7H4Im4dJZnnP46mFIMILlM5pl.iCQ2AorZ4hLOaOurDnLPzy/dA4BllEVOJXLk13bBSYNldF.q/Ei1

# Security
firewall --service=ssh
authconfig --enableshadow --passalgo=sha512
selinux --disabled

# Disks
zerombr
bootloader --location=mbr --driveorder=vda --append="crashkernel=auto rhgb quiet"
clearpart --all --drives=vda,vdb
# vda
part /boot --fstype=ext4 --size=512
part pv.01 --grow --size=1
volgroup vg01 --pesize=4096 pv.01
logvol / --fstype=ext4 --name=sys --vgname=vg01 --grow --size=1024
# vdb
part swap --fstype=swap --grow --size=1

##Network
network --onboot yes --device eth1 --bootproto static --noipv6 --ip=10.243.255.89 --netmask=255.255.255.0 --gateway=10.243.255.1 --nameserver=172.19.243.1
network --onboot yes --device eth0 --bootproto static --noipv6 --ip=172.19.243.89 --netmask=255.255.255.0 --hostname=colombo.dro.nask.pl

%packages
@client-mgmt-tools
@core
@misc-sl
@scalable-file-systems
ntp
ntpdate
openssh-clients
wget
telnet
bind-utils
mc
tcpdump
sysstat
screen
htop
bash-completion
-yum-autoupdate

%post

# add piotrsz
/usr/sbin/useradd piotrsz
mkdir /home/piotrsz/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEA6X8Up+dKhO6IWMDZxsrcGlQiXrlpnKCpfH+WMz+9LI804YXDFeo1QKXKOUgmogWJ8wP9w11xgfR2nYwtwUklgsWWLugPVgmbmj/l3TTbMFyBlfetkBtZpNlzHd7JFM582fyBCIJJcxCvrgQY/tzLYJm4+Z9zNTMcAdcKDxPBoM6QfeghIGkmLco1S4V0WK8akYESfXyw3Rc7mkuon0W2bzoYk5vUKQilNaDE76JkaKw3DGATZ4gQLff/BdUbzl1KqSirqSZ3OPjIZn9+2Watfai+roPpoTsyDuRGed/FEnqgCfLjLMyDuUoFvPzbdzwaLbgbJRkIRdbf0zcPBxPS23GNJFPA4hJh0QrNAAWBqic0I5DUvGzGH3GC/YR485QLpr8OFniycSUEcT6EZF95/GonL0IyxGTM3k6kMv1cUxCBFYepQKzCy37902aChQZsbpm5oZomEzUwZ0FKN1P8x3caDpsuRjDjXIxExrto6O9I/SEUlRukoJu38Pj2f22WZ+jtZ3xsA40BfLVAGdgE+s7z7WRyDxTXgMdiXHckizmVSUqR14EK/skwKBrHa/leI/1sEKWtJvqGDb0E2a+2WqD2FQ39eUynjO0WEJEmEgT9okHxQpOQ/AwgEL7vbV8LovWw+vRNEbHWbJR8hBHBCQrmfOhfrelAi2U6znANdRc= piotrsz@aman.nask.waw.pl" >> /home/piotrsz/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCeqRvo6bBYQbgJrMhCH1pAIcL6QFPZX1K0ULJGmhJ4pO2ZWpKNJsIuvIn4MkIoYjXGTyLitvz+gQjG1SNqIF4ztvmeYyk7K98YEHOwAVxqIJBY0241HLV4VceBcv3nAemVHDYv2rI/HiyKwHT/BVAUZPggsmdpjiqGca7xJ3AWOSPoUXYSDU11J73XxEz3fPcLLDYfif631igMc0kWD8Grv5+Hf6avfdawF07/1s1oZnqQ4dZ6AdXxZ70j6P0Sz9vIu/2qPEC5M8IZCib9sA348qC5GGf7ci+JyNu+m4YUBDIxP2ntdvDHKQgcadVWNBgYm5D0RgI4yY7+hBy39ybKBGx2kSElE7YYmv5NSBlqghUbTWzgOid769Sz5k/0Kgm7+TJJQewxCmzhwInphawjenWDXpcjm0D//ko6NsdNklBHXOTeTN40BxXr52n0a2vpTlB7wDqfCuZ5CXrfFSH9HfNuyoZ+6G+3ETjZJk//b4TRQ/iOwQ/ZdDDjmYHUiznjOu3p/gDxZJ4f5dIKlu+v6n80qNDUndROtTWfWMSypEZ3WgfClP1D6xq1g+emzx5tOjn/U8AQsmHRvPgfKLfVx6mkUDcU7VlyiJV9VaumBGMmPs0DaeWl51Wy2vVPGvAhRI5MF9eHwyzzPCMwvm8nr6VPYSllvf2HrgXVmG938w== piotrsz@gorczyca.nask.waw.pl" >> /home/piotrsz/.ssh/authorized_keys

chmod -R og-rwx /home/piotrsz/.ssh
chown -R piotrsz:piotrsz /home/piotrsz/.ssh



/usr/sbin/useradd marekpl
mkdir /home/marekpl/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2F3IXznTkgS898TEHsRRyMCycvQFmluP8qCUut7lTegbAhyUudRn7AQUkun8xHq/LSGSzmEvfbp4TpUhT4o9w+ejg08Knw1Ek1JLPczEGXFNWtX8ChaxvE00xE+3JVSHO5j/GyOT9Li9ty0kHnhlg6viPm53Vsk2jdgU7YYoWvndLul9YfRSnJ1aIa7tqcBWsVO8BqB90velz3jPgtAvtYSfQnvxgroS4LCtX9k/PKZ3DGgC1rpD5D9h6DmaRiGyHKjmZ92CCZlw0ag8znRNW61eRefuV+yrEbKXyCk8RzjzHsFz61K8tG4REJokgbYakI4HbBBwAbuOw2nvIS1OH plona@brukiew" >> /home/marekpl/.ssh/authorized_keys

chmod -R og-rwx /home/marekpl/.ssh
chown -R marekpl:marekpl /home/marekpl/.ssh



# visudo
echo "" >>  /etc/sudoers
echo "#superusers"
echo "piotrsz ALL=(ALL) NOPASSWD: ALL" >>  /etc/sudoers
echo "marekpl ALL=(ALL) NOPASSWD: ALL" >>  /etc/sudoers

# ntp 
chkconfig ntpdate on
chkconfig ntpd on
cd /tmp
wget http://172.19.243.5/cobbler/files/ntp.conf
cp ./ntp.conf /etc/
rm ./ntp.conf

# iptables
cd /tmp
wget http://172.19.243.5/cobbler/files/iptables
cp ./iptables /etc/sysconfig/iptables
chmod 600 /etc/sysconfig/iptables
rm ./iptables

# yum repo
yum clean all
cd /tmp
rm -rf /etc/yum.repos.d/*
wget http://172.19.243.5/cobbler/files/sl.repo
wget http://172.19.243.5/cobbler/files/epel.repo
wget http://172.19.243.5/cobbler/files/RPM-GPG-KEY-epel
cp sl.repo /etc/yum.repos.d/
cp epel.repo /etc/yum.repos.d/
cp RPM-GPG-KEY-epel /etc/pki/rpm-gpg/
rm ./sl.repo
rm ./epel.repo
rm ./RPM-GPG-KEY-epel

# IPv6 disable
echo "" >> /etc/sysctl.conf
echo "#IPv6 disable" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf

echo "" >> /etc/ssh/sshd_config
echo "#IPv6 disable" >> /etc/ssh/sshd_config
echo "AddressFamily inet" >> /etc/ssh/sshd_config


%end
