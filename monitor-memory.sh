#!/bin/bash

# Usage: monitor-memory.sh <delay> <interval> <output_file>

sleep $1
while true
do
  date >>"$3"
  free --human >>"$3"
  sleep $2
done
