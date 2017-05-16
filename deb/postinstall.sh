#!/bin/bash - 
#===============================================================================
#
#          FILE: postinstall.sh
# 
#         USAGE: ./postinstall.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Marek Płonka (marekpl), marek.plonka@nask.pl
#  ORGANIZATION: DRO-NASK
#       CREATED: 19.12.2016 12:31:36
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
set -o verbose
set -o xtrace

exec 1>/root/postinstall.log 2>&1
cd /tmp || exit 1
tar xvf postinstall.tar
cd postinstall || exit 1
cp etc/tmux.conf /etc
cp etc/profile.d/20mc.sh /etc/profile.d
cp -r root/.config /root
cp root/.bashrc /root
cp root/.profile /root
cp root/.vimrc /root
cp root/.psqlrc /root

cd /etc/ssh || exit 1
cp sshd_config sshd_config.orig
sed -i 's/^PermitRootLogin\s.*/PermitRootLogin yes/' /etc/ssh/sshd_config

ln -s /usr/share/doc/tmux/examples/bash_completion_tmux.sh /etc/bash_completion.d/bash_completion_tmux.sh

cd /usr/bin || exit 1
ln -s tmux t

# grub
cd /etc/default || exit 1
cp grub grub.orig

sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="text"/' grub
sed -i 's/^GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="ipv6.disable=1"/' grub
sed -i 's/^#GRUB_TERMINAL=console/GRUB_TERMINAL=console/' grub
update-grub
