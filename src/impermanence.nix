{ config, pkgs, ... }:

let
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in
{
  imports = [ "${impermanence}/nixos.nix" ];

  boot.tmp.cleanOnBoot = true;

  environment.persistence."/persist" = {
    directories = [
      "/data"
      "/etc/NetworkManager"
      "/etc/nixos"
      "/nix"
      "/tmp"                  # Large builds need more space
      "/var/lib"
      "/var/log"
      "/var/tmp"              # Temp files to be preserved between reboots (source: https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)
    ];
    files = [
      "/etc/adjtime"
      "/etc/machine-id"
      "/etc/passwd"
      "/etc/shadow"
    ];
  };
}
