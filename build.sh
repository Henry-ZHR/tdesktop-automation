#!/bin/bash

set -e
export SHELLOPTS

readonly PKG_URL=https://gitlab.archlinux.org/archlinux/packaging/packages/telegram-desktop.git

echo "::group::Install dependency"
pacman --sync --refresh --sysupgrade --needed --noconfirm git
echo "::endgroup::"

echo "::group::Checkout pkg"
git clone --branch "${VERSION}" --single-branch "${PKG_URL}" pkg
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
  set -x
  cd pkg
  export CMAKE_BUILD_PARALLEL_LEVEL=$(( $(nproc) - 1 ))
  su --command "makepkg --syncdeps --noconfirm" build
  set +x
)
echo "::endgroup::"
