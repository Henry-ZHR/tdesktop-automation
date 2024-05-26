#!/bin/sh

exec /usr/bin/systemd-nspawn --tmpfs=/tmp:size=16G "$@"
