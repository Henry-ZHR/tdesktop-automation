#!/bin/bash

set -e
export SHELLOPTS

readonly PKG_URL=https://gitlab.archlinux.org/archlinux/packaging/packages/telegram-desktop.git

echo "::group::Install dependencies"
pacman --sync --sysupgrade --refresh --needed --noconfirm devtools git
echo "::endgroup::"

echo "::group::Setup makepkg configuration"
cp --force --verbose /usr/share/devtools/makepkg.conf.d/x86_64.conf /etc/makepkg.conf
echo "::endgroup::"

echo "::group::Checkout pkg"
git clone --branch "${PKGVER}" --single-branch "${PKG_URL}" pkg
echo "::endgroup::"

echo "::group::Apply pkg patch"
(
  cd pkg
  git apply --verbose ../patches/pkg/*.patch 
)
echo "::endgroup::"

echo "::group::Prepare to build"
useradd --no-create-home --shell /bin/sh builduser
echo "builduser ALL=(ALL:ALL) NOPASSWD: ALL" | tee --append /etc/sudoers >/dev/null
chmod a+w pkg
echo "::endgroup::"

echo "::group::Makepkg prepare"
(
  cd pkg
  su --command "makepkg --nobuild --syncdeps --noconfirm" builduser
)
echo "::endgroup::"

echo "::group::Apply tdesktop patches"
(
  declare -r patches_dir="$(pwd)/patches/tdesktop"
  cd "pkg/src/tdesktop-${PKGVER}-full"
  mkdir --parents .git
  git apply --verbose ${patches_dir}/*.patch
)
echo "::endgroup::"

echo "::group::Makepkg build"
(
  set -x
  cd pkg
  export CMAKE_BUILD_PARALLEL_LEVEL=$(( $(nproc) - 1 ))
  su --command "makepkg --noextract" builduser
)
echo "::endgroup::"
