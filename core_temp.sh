#!/usr/bin/env bash

sensors | grep -Eo "Core.+: +\+[0-9]+\.[0-9]°" | grep -Eo "[0-9]+\.[0-9]" | sort -n | tail -n1
