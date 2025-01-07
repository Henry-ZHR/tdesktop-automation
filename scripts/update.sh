#!/bin/bash

set -o errexit
set -o pipefail
set -o xtrace


readonly URLS=(https://archlinux.org/packages/extra{,-testing}/x86_64/telegram-desktop/json/)


update_version() {
  if ! curl --fail --head --location "https://archive.archlinux.org/packages/t/telegram-desktop/telegram-desktop-${1}-x86_64.pkg.tar.zst"
  then
    echo "::notice::Failed to download pkg, don't update"
    return
  fi

  echo "${1}" >version.txt

  git config --global --add safe.directory "$(pwd)"
  git add version.txt
  git config user.name "github-actions[bot]"
  git config user.email "github-actions[bot]@users.noreply.github.com"
  git commit --message "Upstream: ${1}"
  git push
}


current_version="$(cat version.txt)"

for url in "${URLS[@]}"
do
  data="$(curl --fail "${url}")" || continue
  pkgver="$(echo "${data}" | jq --raw-output ".pkgver")"
  pkgrel="$(echo "${data}" | jq --raw-output ".pkgrel")"
  epoch="$(echo "${data}" | jq --raw-output ".epoch")"
  version="${pkgver}-${pkgrel}"
  if [ "${epoch}" != 0 ]
  then
    version="${epoch}:${version}"
  fi
  if [ "$(vercmp "${version}" "${current_version}")" -gt 0 ]
  then
    update_version "${version}"
    exit
  fi
done
