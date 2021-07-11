#!/usr/bin/env bash

set -e

SENSORS_OUTPUT="$(sensors)"

echo "$SENSORS_OUTPUT" | grep -Eo "Core.+: +\+[0-9]+\.[0-9]°" | grep -Eo "[0-9]+\.[0-9]" | sort -n | tail -n1
