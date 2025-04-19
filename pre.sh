#!/bin/bash

FULL_DEPS=(
  @^workstation-product-environment
  vim-enhanced
  vim-default-editor
)

#clear screen
printf '\033[2J'
printf '\033[H'

rm -f /tmp/include

#installation target: a nonremovable disk that is not mounted
TARGET_DEVICE=$(lsblk -no RM,TYPE,MOUNTPOINTS,KNAME | sed -n -E '/^0\s+disk\s+(\S+)$/ s//\1/p')
lsblk
echo "Using target device: $TARGET_DEVICE"
echo "All data on the target device will be erased."
echo "Is this OK? [Y/n]"
read -r

if [[ ${REPLY:-y} =~ [Yy] ]]; then
  {
    echo "ignoredisk --only-use=$TARGET_DEVICE"
    echo %packages
    echo ${FULL_DEPS[@]} | tr ' ' '\n'
    echo %end
  } >> /tmp/include
  touch /tmp/start
  sleep 5
else
  {
    echo "ignoredisk --only-use=$TARGET_DEVICE"
    echo -e "%packages\n@core\n%end"
  } >> /tmp/include
  echo "Installation halted."
  echo "Use this terminal to investigate, or reboot the system."
  #...or edit /tmp/include, then touch /tmp/start
fi
