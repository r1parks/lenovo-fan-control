#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
  echo "You must run this script as root."
  exit 1
fi

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

while :
do
	TEMP="$("$SOURCE_DIR"/core_temp.sh)"
	FAN_LEVEL="$("$SOURCE_DIR"/fan_level.py "$TEMP")"
	echo "level $FAN_LEVEL" > /proc/acpi/ibm/fan
	echo "temperature ${TEMP}c, set fan level $FAN_LEVEL"
	sleep 10
done
