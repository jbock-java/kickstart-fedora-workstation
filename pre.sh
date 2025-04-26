#!/bin/bash

PACKAGES=(
  @core
  @c-development
  xz-devel
  git
  ugrep
  tmux
  keychain
  vim-enhanced
  vim-default-editor
  vim-gitgutter
  vim-fugitive
  vim-ctrlp
)

#clear screen
printf '\033[2J'
printf '\033[H'

FEDORA_VERSION=$(sed -E 's/^.*\b([[:digit:]]+)\b.*$/\1/' /etc/fedora-release)
TARGET_DEVICE=$(lsblk -no RM,TYPE,MOUNTPOINTS,KNAME | sed -n -E '/^0\s+disk\s+(\S+)$/ s//\1/p')

{
  echo "ignoredisk --only-use $TARGET_DEVICE"
  echo "url --mirrorlist 'https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-${FEDORA_VERSION}&arch=x86_64'"
  echo "network --device=link --hostname f${FEDORA_VERSION}"
  echo %packages
  echo ${PACKAGES[@]} | tr ' ' '\n'
  echo %end
} > /tmp/include

echo "Using Fedora version: $FEDORA_VERSION"
echo "Using target device: $TARGET_DEVICE"
echo "All data on the target device will be erased."
echo "Is this OK? [Y/n]"
read -r

[[ ! ${REPLY:-y} =~ [Yy] ]] && {
  echo "Installation stopped."
  exit 0
}

#break the waiting loop
touch /tmp/start
sleep 5
