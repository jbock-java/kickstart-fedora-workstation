## Fedora Workstation Kickstart File

Download (Network Installer image)[https://alt.fedoraproject.org/].

Remove `quiet` and add `inst.cmdline inst.ks=http://XXX.XXX.XXX.XXX:1234/my.ks` to grub cmdline.
