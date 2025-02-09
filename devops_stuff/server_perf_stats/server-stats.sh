#!/bin/bash
# Analyze basic server performance stats
num_cores=$(lscpu | grep '^CPU(s):' | awk '{ print $2}')
# Running top command several times will slow things down
cpu_usage=$(top -bn2 | grep '%Cpu' | tail -1 | grep -P '(....|...) id,'| awk  -v n_cores=$num_cores '{print "CPU Usage: " 100-$8/n_cores "%"}')
mem_usage=$(top -bn2 | grep 'MiB Mem' |top -bn2 | grep 'MiB Mem' | tail -1 | awk '{ printf "Mem usage:"; for (i=4; i<=9; i++) printf " " $i; printf "\n" }')
disk_usage=$(df -h --total | tail -1 | awk '{ print "Disk usage: " $3 " Used, " $4 " Avaliable (" $5 " usage)"}')

arr_stats=($cpu_usage, $mem_usage)

timestamp=$(date +%F_%H:%M)
echo "--------------------------------------------------"
echo "Current Server Performance Stats at $timestamp"
echo "--------------------------------------------------"
echo
echo "Basic Stats"
echo "---------------"
# for i in "${arr_stats[@]}"; do echo $i; done
echo "$cpu_usage"
echo "$mem_usage"
echo "$disk_usage"
echo "Top 5 processes by CPU usage"
echo "--------------------------------"
ps aux --sort -%cpu | head -n 5
echo
echo "Top 5 processes by memory usage"
echo "--------------------------------"
ps aux --sort -%mem | head -n 5
echo

echo "Bonus things!!"
echo "-------------------------------"
grep PRETTY_NAME /etc/os-release | sed -e 's/PRETTY_NAME=//' | awk '{ print "OS version: " $0 }'
uptime -p | awk '{print "Server uptime: " $0 }'
uptime | awk -F'load average: ' '{print "Load average: " $2}'
users | awk '{ print "Logged in users: " $0 }'
echo

echo "Extra Bonus things to print"
echo "-------------------------------"
groups | awk '{ print $USER " is part of the following groups:"; for (i = 1; i <= NF; i++) {print $i} }'
