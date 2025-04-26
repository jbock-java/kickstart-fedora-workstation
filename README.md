## Fedora Workstation Kickstart File

Generate `my.cfg`:

```
./replace_password <<< SecretPassword123
```

Start a http server:

```
python3 -m http.server --bind XXX.XXX.XXX.XXX 3000
```

Meanwhile, download Network Installer iso from [alt.fedoraproject.org](https://alt.fedoraproject.org/).

Either burn the the iso to usb, or run it in a virtual machine.

When the iso starts, the first thing you will see is a grub boot menu.

Edit the first entry ("Install Fedora" or something) by pressing "e" on your keyboard.

In grub cmdline, remove `quiet` and add `inst.ks=http://XXX.XXX.XXX.XXX:3000/my.cfg`.

Now press F10 to start the installation.
