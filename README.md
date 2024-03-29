# My NixOS Setup

## Prerequesites
* Ensure dwm, dmenu, slstatus and nixos code is committed and pushed with clean stage
*

## Bootstrapping a new machine

WARNING: Disk needs to be set in 2 places at the moment: secrets/machine/device
and src/machine/minimal.nix. Need to set minimal.nix to pull from device

Initial build is expecting to find dmenu, dwm and slstatus in the /data/code directory


* Copy this repo to a USB stick
* Add the ssh key to GitHub
* Create another USB stick with the minimal NixOS ISO from https://nixos.org/download
* Boot up NixOS ISO then run the following commands:
```
sudo -s
mkdir /usb
mount /dev/disk/by-label/nixos-files /usb
cd /usb
./bootstrap -pf <darko|spruce>     # Partition and format the drives
```

After first boot, run:
```
sudo mkdir /usb
sudo mount /dev/disk/by-label/nixos-files /usb
cd /usb
./initialize
./build -s
```

## Directory structure

```
USB/
  secrets/
    bashrc.local
    common.env
    machine/
      ssh/
      device                # SSD
      syncthing.cert.pem
      syncthing.key.pem
  dotfiles/   # dotfiles imported by Nix
  neovim/     # Lua and vim file imported by Nix
  src/
    *.nix     # Nix source configuration files
  bootstrap   # Build script for clean machine
  initialize  # Setup a few things after initial install is complete, private keys etc
  build     # Build script for NixOS machine
  *.sh        # additional build scripts used by bootstrap and build
```


## References
* https://www.gnu.org/software/parted/manual/parted.html
* https://qfpl.io/posts/installing-nixos/
* https://nixos.org/manual/nixos/stable/
* https://discourse.nixos.org/t/tips-tricks-for-nixos-desktop/28488
* https://nixos.wiki/wiki/Backlight