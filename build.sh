#!/bin/bash

set -e -o pipefail
export SHELLOPTS

echo "::group::Install dependencies"
(
  set -x
  pacman --sync --refresh --sysupgrade --needed --noconfirm git python
)
echo "::endgroup::"

echo "::group::Checkout pkg"
(
  set -x
  git clone "${URL}" pkg
  git -C pkg reset --hard "${COMMIT}"
)
echo "::endgroup::"

echo "::group::Apply pkg patch"
(
  set -x
  cd pkg
  git apply --verbose ../patches/pkg/*.patch 
)
echo "::endgroup::"

echo "::group::Prepare to build"
(
  set -x
  useradd --no-create-home --shell /bin/sh build
  echo "build ALL=(ALL:ALL) NOPASSWD: ALL" | tee --append /etc/sudoers
  chmod a+w pkg
)
echo "::endgroup::"

echo "::group::Build package"
(
  set -x
  su --command "makepkg --syncdeps --noconfirm" build
)
echo "::endgroup::"
