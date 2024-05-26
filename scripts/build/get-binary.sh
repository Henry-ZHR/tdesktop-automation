#!/bin/bash

set -o errexit
set -o xtrace


readonly archive_name="telegram-desktop-${VERSION}-x86_64.pkg.tar.zst"

curl --fail --remote-name "https://archive.archlinux.org/packages/t/telegram-desktop/${archive_name}"

mkdir pkgdir
tar --extract --file "${archive_name}" --directory pkgdir --verbose
(
  cd pkgdir
  sed --in-place "s/pkgbuild_sha256sum .*/pkgbuild_sha256sum = $(sha256sum /mnt/pkg/PKGBUILD | awk '{print $1}')/g" .BUILDINFO
  tar --create --file "/mnt/pkg/${archive_name}" --auto-compress --verbose -- * .[^.]*
)
rm --force --recursive "${archive_name}" pkgdir
