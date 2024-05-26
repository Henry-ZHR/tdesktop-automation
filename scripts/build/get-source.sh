#!/bin/bash

set -o errexit
set -o xtrace


sudo chmod --verbose a+w /mnt

git clone --branch "${VERSION}" --single-branch https://gitlab.archlinux.org/archlinux/packaging/packages/telegram-desktop.git /mnt/pkg

repo_dir=$(pwd)

(
  cd /mnt/pkg

  for patch in "${repo_dir}"/patches/pkg/*.patch
  do
    patch --strip=1 --input="${patch}"
  done

  cat >>PKGBUILD <<'EOF'
prepare() {
  cd "tdesktop-${pkgver}-full"
  for patch in ../*.patch
  do
    patch --strip=1 --input="${patch}"
  done
}
EOF

  for patch in "${repo_dir}"/patches/tdesktop/*.patch
  do
    uuid="$(uuidgen)"
    cp "${patch}" "${uuid}.patch"
    echo "source+=(${uuid}.patch)" >>PKGBUILD
    echo "sha512sums+=(SKIP)" >>PKGBUILD
  done
)
