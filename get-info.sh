#!/bin/bash

for key in repo version pkgname; do
  value=$(jq -r .$key info.json)
  echo "$key: $value"
  echo "$key=$value" >>$GITHUB_OUTPUT
done
