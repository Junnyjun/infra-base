#!/bin/bash

sudo dpkg --add-architecture i386
sudo apt update
sudo apt install software-properties-common lib32gcc-s1 steamcmd wine xvfb

sudo useradd -m -s /bin/bash steam
sudo -iu steam
mkdir ~/conan_exiles
cd ~/conan_exiles

echo 'export PATH="/usr/games:$PATH"' >> ~/.profile
source ~/.profile

steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir ~/conan_exiles +login anonymous +app_update 443030 validate +quit

export WINEARCH=win64
export WINEPREFIX=~/.wine64

xvfb-run --auto-servernum --server-args='-screen 0 640x480x24:32' wine ~/conan_exiles/ConanSandboxServer.exe -log
