## Fedora Workstation Kickstart File

Generate `my.ks`:

```
./replace_password <<< SecretPassword123
```

Download [Network Installer image](https://alt.fedoraproject.org/).

In grub cmdline, remove `quiet` and add `inst.ks=http://XXX.XXX.XXX.XXX:1234/my.ks inst.cmdline`.
