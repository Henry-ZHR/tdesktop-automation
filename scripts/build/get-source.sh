#!/bin/bash

set -o errexit
set -o xtrace


readonly MAGIC='O59Z'


sudo chmod --verbose a+w /mnt

git clone --branch "${VERSION}" --single-branch https://gitlab.archlinux.org/archlinux/packaging/packages/telegram-desktop.git /mnt/pkg

repo_dir=$(pwd)

(
  cd /mnt/pkg

  for patch in "${repo_dir}"/patches/pkg/*.patch
  do
    patch --strip=1 --input="${patch}"
  done

  sed -i 's/prepare/_prepare' PKGBUILD
  cat "MAGIC=\"${MAGIC}\"" >> PKGBUILD
  cat >>PKGBUILD <<'EOF'
prepare() {
  if declare -f _prepare >/dev/null
  then
    _prepare
  fi

  cd "${srcdir}"
  cd "tdesktop-${pkgver}-full"
  for patch in ../${MAGIC}-*.patch
  do
    patch --strip=1 --input="${patch}"
  done
}
EOF

  for patch in "${repo_dir}"/patches/tdesktop/*.patch
  do
    filename="${MAGIC}-$(basename "${patch}")"
    cp "${patch}" "${filename}"
    echo "source+=(${filename})" >>PKGBUILD
    echo "sha512sums+=(SKIP)" >>PKGBUILD
  done
)
