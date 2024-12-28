#!/bin/bash -e


function start_group() {
  echo "::group::$1"
}
function end_group() {
  echo "::endgroup::"
}

function apply_patches() {
  for patch in "$@"
  do
    echo "Applying patch: ${patch}"
    patch --strip=1 --input="${patch}"
  done
}


cd telegram-desktop

start_group "Patch PKGBUILD"
apply_patches ../patches/pkg/*.patch
end_group

start_group "makepkg prepare"
makepkg --nobuild --syncdeps --noconfirm
end_group

(
  start_group "Patch src"
  cd src/tdesktop-*-full
  apply_patches ../../../patches/tdesktop/*.patch
  end_group
)

start_group "makepkg build & package"
makepkg --noextract
end_group
