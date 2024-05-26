#!/bin/bash

# Usage: monitor-disk.sh <delay> <interval> <output_file>

# shellcheck disable=SC2086
sleep $1
while true
do
  date >>"$3"
  df --human-readable >>"$3"
  sleep $2
done
