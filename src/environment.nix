{ config, pkgs, lib, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.dataDir} - ${config.username} users"
    "d ${config.dataDir}/downloads - ${config.username} users"
    "d ${config.codeDir} - ${config.username} users"
    "d ${config.dataDir}/work - ${config.username} users"
  ];

  environment = {
    sessionVariables = {
      DATA = config.dataDir;
      CODE = config.codeDir;
      SRC = "${config.codeDir}/nixos-files";
      NOTES  = "${config.dataDir}/notes";
      CDPATH = "${config.dataDir}/work:${config.codeDir}:${config.dataDir}";
      DOTNET_CLI_TELEMETRY_OPTOUT = "true";
      FZF_DEFAULT_COMMAND = "rg --files --no-ignore-vcs --hidden --ignore-file ~/.ignore";
      HISTCONTROL = "ignorespace:erasedups";   # Don't add commands starting with space, remove previous occurrances of command
      HISTFILESIZE = "-1";                       # Unlimited history
      HISTSIZE = "-1";                           # Unlimited history

      XDG_CONFIG_HOME = config.xdgConfigHome;
      XDG_DATA_HOME = config.xdgDataHome;
    };

    etc = {
      "xdg/nvim/colors/greyscale.vim".source = ../neovim/colors/greyscale.vim; # FIXME: This shouldn't be here
      "gitignore".source = ../dotfiles/gitignore;
      "ignore".source = ../dotfiles/ignore;
    };
  };
}