%include /tmp/included

%pre --log=/tmp/prelog.txt
rm -f /tmp/included
#target: nonremovable disk that is not mounted
TARGET_DEVICE=$(lsblk -no RM,MOUNTPOINTS,KNAME | sed -n -E '/^0\s+(\S+)$/ s//\1/p')
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
%end
