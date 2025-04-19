%include /tmp/include

%pre --log=/tmp/prelog.txt
INST_KS=$(sed -E 's/.*\binst[.]ks=(\S+).*/\1/' /proc/cmdline)
curl -m9 -s -o /tmp/pre.sh "$(dirname ${INST_KS})/pre.sh"
chmod +x /tmp/pre.sh
tmux select-window -t2
tmux send-keys -t2 "/tmp/pre.sh" C-m
while [[ ! -a /tmp/start ]]; do
  sleep 2
done
tmux select-window -t1
%end

url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-42&arch=x86_64"

rootpw --iscrypted "$userpass"
user --name=core --iscrypted --password "$userpass" --groups wheel

clearpart --all --initlabel
zerombr
part /boot/efi --label=LINUXEFI --size=600
part /boot --label=linuxboot --fstype=ext4 --size=1024
part / --size=16000 --grow --fstype=ext4 --label=linuxroot

bootloader --append="panic=60" --sdboot
network --device=link --hostname=box
keyboard us
lang en_US
timezone Europe/Berlin
text
reboot
firstboot --disable

%post --nochroot
%end

%post --log=/tmp/postlog.txt
#we need the installed kernel, which can differ from the running kernel
KERNEL_VERSION=$(basename $(ls -d -1 /usr/lib/modules/*x86_64))
#sample boot config editing
sed -i -E '/^options\b/ s/\bquiet\b//;s/\brhgb\b//' /boot/efi/loader/entries/*${KERNEL_VERSION}.conf
%end
