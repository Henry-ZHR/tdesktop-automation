#!/bin/bash

set -e
export SHELLOPTS

echo "::group::Install dependencies"
pacman --sync --refresh --sysupgrade --needed --noconfirm git python
echo "::endgroup::"

echo "::group::Checkout pkg"
git clone --branch "${VERSION}" --single-branch pkg
echo "::endgroup::"

echo "::group::Apply pkg patch"
(
  cd pkg
  git apply --verbose ../patches/pkg/*.patch 
)
echo "::endgroup::"

echo "::group::Prepare to build"
useradd --no-create-home --shell /bin/sh build
echo "build ALL=(ALL:ALL) NOPASSWD: ALL" | tee --append /etc/sudoers >/dev/null
chmod a+w pkg
echo "::endgroup::"

echo "::group::Build package"
(
  cd pkg
  su --command "makepkg --syncdeps --noconfirm" build
)
echo "::endgroup::"
