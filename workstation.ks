%include /tmp/included

%pre --log=/tmp/prelog.txt
rm -f /tmp/included
TARGET_DEVICE=$(lsblk -no RM,MOUNTPOINTS,KNAME | sed -n -E '/^0\s+(\S+)$/ s//\1/p')
tmux select-window -t 2
tmux send-keys -t 2 "lsblk" C-m
tmux send-keys -t 2 "echo target device: $TARGET_DEVICE" C-m
tmux send-keys -t 2 'echo touch /tmp/start to break the loop' C-m
while [[ ! -a /tmp/start ]]; do
  sleep 2
done
tmux select-window -t 1
#target: nonremovable disk that is not mounted
cat >> /tmp/included <<EOF
ignoredisk --only-use=$TARGET_DEVICE
EOF
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

%packages
@^workstation-product-environment
vim-default-editor
vim-enhanced
vim-ctrlp
%end

%post --nochroot
%end

%post --log=/tmp/postlog.txt
#we need the installed kernel, which can differ from the running kernel
KERNEL_VERSION=$(basename $(ls -d -1 /usr/lib/modules/*x86_64))
#sample boot config editing
sed -i -E '/^options\b/ s/\bquiet\b//;s/\brhgb\b//' /boot/efi/loader/entries/*${KERNEL_VERSION}.conf
%end
