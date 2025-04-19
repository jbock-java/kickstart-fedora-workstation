## Fedora Workstation Kickstart File

Download Fedora (Network Installer image)[https://alt.fedoraproject.org/].

Remove `quiet` and append `inst.cmdline inst.ks=http://XXX.XXX.XXX.XXX:1234/my.ks` to grub cmdline.
