{ config, pkgs, ... }:

{
  systemd.tmpfiles.rules = [
    "d /data - phil users"
    "d /data/downloads - phil users"
  ];

  environment = {
    sessionVariables = rec {
      # Duplicated in ./initialize
      DATA = "/data";
      CODE = "${DATA}/code";
      SRC = "${CODE}/nixos-files";
      TXT  = "${DATA}/txt";
      CDPATH   = "${CODE}:${DATA}";
      DOTNET_CLI_TELEMETRY_OPTOUT = "true";
      FZF_DEFAULT_COMMAND = "rg --files --no-ignore-vcs --hidden --ignore-file ~/.ignore";
      HISTCONTROL = "ignorespace:erasedups";   # Don't add commands starting with space, remove previous occurrances of command
      HISTFILESIZE = "";                       # Unlimited history
      HISTSIZE = "";                           # Unlimited history
      XDG_CONFIG_HOME = "$HOME/.config";
      GTK_THEME = "Adwaita:dark";
    };

    etc = {
      "bashrc.local".source = ../secrets/bashrc.local;
      "xdg/nvim/colors/greyscale.vim".source = ../neovim/colors/greyscale.vim;
      "gitignore".source = ../dotfiles/gitignore;
      "ignore".source = ../dotfiles/ignore;
    };
  };
}
