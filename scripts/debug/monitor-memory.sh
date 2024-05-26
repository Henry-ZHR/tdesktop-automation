#!/bin/bash

# Usage: monitor-memory.sh <delay> <interval> <output_file>

# shellcheck disable=SC2086
sleep $1
while true
do
  date >>"$3"
  free --human >>"$3"
  sleep $2
done
