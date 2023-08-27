{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./common.nix
    ];

  networking.hostName = "darko";

  services.auto-cpufreq.enable = true;
  programs.light.enable = true;

  environment.systemPackages = with pkgs; [
  ];

}

