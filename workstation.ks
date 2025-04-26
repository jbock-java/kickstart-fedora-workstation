%include /tmp/include

%pre --log=/tmp/prelog.txt
INST_KS=$(sed -E 's/.*\binst[.]ks=(\S+).*/\1/' /proc/cmdline)
curl --fail -m9 -s -o /tmp/pre.sh "$(dirname ${INST_KS})/pre.sh"
curl --fail -m9 -s -o /tmp/post.sh "$(dirname ${INST_KS})/post.sh"
chmod +x /tmp/pre.sh
chmod +x /tmp/post.sh
tmux select-window -t2
tmux send-keys -t2 "/tmp/pre.sh" C-m
while [[ ! -a /tmp/start ]]; do
  sleep 2
done
tmux select-window -t1
%end

rootpw --iscrypted "$userpass"
user --name=core --iscrypted --password "$userpass" --groups wheel

clearpart --all --initlabel
zerombr
part /boot/efi --label=LINUXEFI --size=600
part /boot --label=linuxboot --fstype=ext4 --size=1024
part / --size=16000 --grow --fstype=ext4 --label=linuxroot

bootloader --append panic=60 --sdboot
keyboard us
lang en_US
timezone Europe/Berlin
text
reboot
firstboot --disable

%post --nochroot
mkdir -p /mnt/sysroot/root/archive
cp /tmp/prelog.txt /mnt/sysroot/root/archive
cp /tmp/include /mnt/sysroot/root/archive
cp /tmp/post.sh /mnt/sysroot/root
%end

%post --log=/root/archive/postlog.txt
/root/post.sh
mv /root/post.sh /root/archive
%end
