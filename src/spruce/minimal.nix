{ config, pkgs, ... }:

{
  imports = [ ../minimal.nix ];

  networking.hostName = "spruce";
  boot.initrd.luks.devices.root.device = "/dev/nvme2n1p2";

  fileSystems."/games-old" = {
    device = "/dev/disk/by-label/games";
    fsType = "ext4";
  };

  fileSystems."/games" = {
    device = "/dev/disk/by-label/Games";
    fsType = "ntfs";
    options = [ "rw" "uid=1000" ];
  };
}