#!/bin/bash
# Analyze basic server performance stats
num_cores=$(lscpu | grep '^CPU(s):' | awk '{ print $2}')
# Running top command several times will slow things down
cpu_usage=$(top -bn2 | grep '%Cpu' | tail -1 | grep -P '(....|...) id,'| awk  -v n_cores=$num_cores '{print "CPU Usage: " 100-$8/n_cores "%"}')
mem_usage=$(top -bn2 | grep 'MiB Mem' |top -bn2 | grep 'MiB Mem' | tail -1 | awk '{ printf "Mem usage:"; for (i=4; i<=9; i++) printf " " $i; printf "\n" }')

arr_stats=($cpu_usage, $mem_usage)

timestamp=$(date +%F_%H:%M)
echo "--------------------------------------------------"
echo "Current Server Performance Stats at $timestamp"
echo "--------------------------------------------------"
echo
echo "Basic Stats"
echo "---------------"
# for i in "${arr_stats[@]}"; do echo $i; done
echo cpu_usage
echo mem_usage

echo
echo "Extra Bonus things to print"
echo "-------------------------------"
groups_list= $(groups | awk '{ print $USER " is part of the following groups:"; for (i = 1; i <= NF; i++) {print $i} }')
echo $groups_list