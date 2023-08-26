#!/bin/sh

if [ -z "$1" ]; then
  machine=$(hostname)
else
  machine=$1
fi

case $machine in
  "darko")
    ;;
  "spruce")
    ;;
  *)
    echo "Usage: $0 <darko|spruce>"
    exit
    ;;
esac

source ./common.env
source ./$machine.env

echo "[REBUILD] $machine"

# Copy SSH dir if not already
if [ ! -d "$HOME/.ssh" ]; then
  cp -R ./.ssh ~/
  chmod 600 $HOME/.ssh/*
fi

# Setup Wifi if not already
ping -c 1 google.com > /dev/null 2>&1 || sudo iwctl --passphrase=$psk station wlan0 connect $ssid

./copy_config.sh $machine /etc/nixos 0 # 0 - No dryrun

cd ~ # Needed as rebuild symlinks the result from the current path
sudo nixos-rebuild switch
cd -
