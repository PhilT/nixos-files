{ config, pkgs, ... }:

{
  imports =
    [
      ./minimal.nix
      ./power.nix
      ../phil.nix
      ../nvidia.nix
    ];

  programs.alacritty.fontSize = 11;

  services.syncthing.key = "${../../secrets/spruce/syncthing.key.pem}";
  services.syncthing.cert = "${../../secrets/spruce/syncthing.cert.pem}";

  environment.systemPackages = with pkgs; [
  ];
}

