#!/bin/bash

interval=1
timeout=30

setf() {
	cpupower frequency-set -f "$1MHz" > /dev/null
}

set_boost() {
	echo "$1" > /sys/devices/system/cpu/cpufreq/boost
}

run_test() {
	pstate=$1
	config=$2
	echo "test run: $pstate $config"

	echo 3 > /proc/sys/vm/drop_caches
	sleep 1

	cpupower frequency-set -g userspace > /dev/null

	case "$pstate" in
		"P2")
			set_boost 0
			setf 1500
			;;
		"P1")
			set_boost 0
			setf 2200
			;;
		"P0")
			set_boost 0
			setf 3000
			;;
		"PB")
			set_boost 1
			setf 3000
			;;
		*)
			echo "invalid P-state: $pstate"
			exit 1
	esac

	case "$config" in
		# threads-cores-CCXx
		"1-1")
			cpuset="32"
			numcpu=1
			;;
		"2-1")
			# 2 cores on same CPU
			cpuset="1,33"
			numcpu=2
			;;
		"2-2")
			# 2 cores on 2 different CPUs
			cpuset="34,35"
			numcpu=2
			;;
		"64-32")
			cpuset="0-63"
			numcpu=32
			;;
		*)
			echo "invalid config: $config"
			exit 1
	esac

	echo "$cpuset" > "$pstate-$config.cpuset"

	cpupower frequency-info > "$config.info"

	turbostat -q --interval "$interval" -out "$pstate-$config.out" taskset -c "$cpuset" stress --cpu "$numcpu" --timeout "$timeout"
}

echo 0 > /proc/sys/kernel/numa_balancing
echo 0 > /proc/sys/kernel/randomize_va_space
swapoff -a

for pstate in "P2" "P1" "P0" "PB"
do
	for config in "1-1" "2-1" "2-2" "64-32"
	do
		run_test "$pstate" "$config"
		echo "Sleeping..."
		sleep 30
	done
done
