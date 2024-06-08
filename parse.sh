#!/bin/bash

echo "| P-state | Config | CPU Set | CorWatt | PkgWatt |"
echo "|---------|--------|---------|---------|---------|"

for pstate in "P0" "P1" "P2" "PB"
do
	for config in "1-1" "2-1" "2-2" "64-32"
	do
		cpuset=$(cat "$pstate-$config.cpuset")
		corwatt=$(cat "$pstate-$config.out" | sed -n "3p" | awk -F'\t' '{ print $(NF-1) }')
		pkgwatt=$(cat "$pstate-$config.out" | sed -n "3p" | awk -F'\t' '{ print $(NF-2) }')
		printf "| %-7s | %-6s | %-7s | %-7s | %-7s |\n" "$pstate" "$config" "$cpuset" "$corwatt" "$pkgwatt"
	done
done
