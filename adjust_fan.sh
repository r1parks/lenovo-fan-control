#!/usr/bin/env bash


set -x

SOURCE_DIR=/home/robert/git/lenovo-fan-control

while :
do
	TEMP="$($SOURCE_DIR/core_temp.sh)"
	FAN_LEVEL="$($SOURCE_DIR/fan_level.py "$TEMP")"
	echo "level $FAN_LEVEL" > /proc/acpi/ibm/fan
	sleep 10
done
