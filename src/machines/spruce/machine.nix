{ config, pkgs, ... }: {
  machine = "spruce";
  username = "phil";
  fullname = "Phil Thompson";

  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-uuid/LUKS_UUID";
    preLVM = true;
  };
}