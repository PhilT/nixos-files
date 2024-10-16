# The Steam client will be downloaded or updated at ~/.local/share/Steam by default.
#
# lsusb - to check hardware IDs
#

# To get Joysticks working for some Proton/Wine games follow these steps:
#
# * Find the steamid for the game by name with:
#     grep -i "<name e.g. elite>" /games/steam/steamapps/appmanifest_*.acf
#
# * Import the reg keys:
#     env WINEPREFIX=$STEAM_LIBRARY/compatdata/<steamid>/pfx regedit joysticks/winebus.reg
#     env WINEPREFIX=$STEAM_LIBRARY/compatdata/<steamid>/pfx regedit joysticks/enum_winebus.reg
#

{ config, pkgs, ... }:

let
  steam_dir = "/games/steam";
in
{
  nixpkgs.config.allowUnfree = true;
  programs.steam.enable = true;
  programs.gamemode.enable = true; # Run with: gamemoderun ./game, verify with: gamemoded -s

  security.wrappers.bluepy-helper = {
    owner = "root";
    group = "root";
    capabilities = "cap_net_raw,cap_net_admin+eip";
    source = "${pkgs.python3Packages.bluepy}/${pkgs.python312.sitePackages}/bluepy/bluepy-helper";
  };

  environment = {
    sessionVariables = {
      STEAM_DIR = steam_dir;
      STEAM_LIBRARY = "${steam_dir}/steamapps";
    };

    systemPackages = with pkgs; [
      game-devices-udev-rules # Udev rules to make controllers available with non-sudo permissions
      lutris                  # For non-steam games from other app stores or local, also supports steam games
      jstest-gtk              # For testing Joysticks
    ];
  };

  systemd.tmpfiles.rules = [
    "d ${config.userHome}/log - ${config.username} users -"
    "d ${config.userHome}/.local/share/Steam - ${config.username} users -"
  ];

  # Create a bind mount to steamapps folder (declared in src/spruce/minimal.nix)
  # (symlinking causes issues)
  fileSystems."${config.userHome}/.local/share/Steam/steamapps" = {
    device = "/games/steam/steamapps";
    options = [ "bind" ];
  };
}