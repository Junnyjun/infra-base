#! /bin/bash
echo "UPDATE APT"
sudo apt-get update -y
sudo apt-get upgrade -y

echo "SET TIME ZONE"
sudo timedatectl set-timezone Asia/Seoul
sudo timedatectl set-local-rtc no
sudo timedatectl set-ntp yes

sudo apt install -y tzdata
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

echo "SET LANG"
sudo apt-get install locales
sudo dpkg-reconfigure locales
sudo locale-gen ko_KR.UTF-8
sudo update-locale LC_ALL=ko_KR.UTF-8 LANG=ko_KR.UTF-8
export LANG=ko_KR.UTF-8
export LC_ALL=ko_KR.UTF-8
