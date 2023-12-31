{ config, pkgs, ... }:

{
  programs = {
    # `j term` cd quickly
    autojump.enable = true;

    # Autorun nix-shell when entering a dir with a shell.nix (e.g. a .NET project)
    direnv.enable = true;

    dconf.enable = true;
    # xautolock also added in services
    #slock.enable = true;

    # Starship - Highly configurable shell prompt
    starship.enable = true;

    bash.shellAliases = {
      ss = "feh -Z -F -D 15";
      invoice = "nix-shell $CODE/sheetzi/shell.nix --command $CODE/sheetzi/invoice";
    };
  };

  environment = {
    systemPackages = with pkgs; [
      (callPackage ./studio.nix {})
      (callPackage ./godot.nix {})
      (callPackage ./spectrum.nix {})

      # Reset file/folder permissions
      (writeShellScriptBin "resetperms" ''
        find . -type d -print0 | xargs -0 chmod 755
        find . -type f -print0 | xargs -0 chmod 644
      '')

      (writeShellScriptBin "slk" ''
        if [ "$(hostname)" == "darko" ]; then
          export __NV_PRIME_RENDER_OFFLOAD=1
          export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
          export __GLX_VENDOR_LIBRARY_NAME=nvidia
          export __VK_LAYER_NV_optimus=NVIDIA_only
        fi

        /run/current-system/sw/bin/slack
      '')

      # System information: lsusb, lspci, lscpu, lsblk
      usbutils
      pciutils
      cpu-x

      mpv                   # Video player
      element-desktop       # Matrix chat client Connect to: #pimalaya.himalaya
      discord
      fd                    # Alternative to find
      feh
      flameshot             # Screnshot tool
      gimp
      inkscape
      keepassxc
      libreoffice
      pinentry              # TODO: What is this?
      pulseaudio
      ripgrep
      shared-mime-info      # Recognise different file types
      slack
      surf
      unzip
      vengi-tools           # Voxel tools including VoxEdit
      whatsapp-for-linux
      wineWowPackages.full  # Needed for FL Studdio installer
      xclip                 # Used by Neovim among other things for copy/paste from/to system clipboard
      zip
    ];
  };
}