#!/bin/sh

pacman -Syu --noconfirm
pacman -S --noconfirm sudo

useradd --no-create-home --shell /bin/sh build
echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
su -c "makepkg -s --noconfirm" build
