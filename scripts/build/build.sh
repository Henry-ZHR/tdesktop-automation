#!/bin/bash -ex

cd telegram-desktop
for patch in ../patches/pkg/*.patch
do
  patch --strip=1 --input="${patch}"
done
makepkg --nobuild --syncdeps --noconfirm
for patch in ../patches/tdesktop/*.patch
do
  patch --strip=1 --input="${patch}"
done
makepkg --noextract
