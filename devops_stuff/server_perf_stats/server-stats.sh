#!/bin/bash

# Analyze basic server performance stats
print_basic_stats() {
  num_cores=$(lscpu | grep '^CPU(s):' | awk '{ print $2}')
  # Running top command several times will slow things down
  cpu_usage=$(top -bn2 | grep '%Cpu' | tail -1 | grep -P '(....|...) id,'| awk  -v n_cores=$num_cores '{print "CPU Usage: " 100-$8/n_cores "%"}')
  mem_usage=$(free -m | grep 'Mem' | awk '{ print "Mem usage: " $3 "MB used, " $4 "MB free" }')
  disk_usage=$(df -h --total | tail -1 | awk '{ print "Disk usage: " $3 " Used, " $4 " Avaliable (" $5 " usage)"}')
  echo "Basic Stats"
  echo "---------------"
  # arr_stats=($cpu_usage, $mem_usage)
  # for i in "${arr_stats[@]}"; do echo $i; done
  echo $cpu_usage
  echo $mem_usage
  echo $disk_usage
}

print_process_stats() {
  echo "Top 5 processes by CPU usage"
  echo "--------------------------------"
  echo | ps aux --sort -%cpu | head -n 5
  echo
  echo "Top 5 processes by memory usage"
  echo "--------------------------------"
  echo | ps aux --sort -%mem | head -n 5
  echo
}

# Print info about server OS version, uptime, load averages, users logged in
print_bonus_info() {
  echo | grep PRETTY_NAME /etc/os-release | sed -e 's/PRETTY_NAME=//' | awk '{ print "OS version: " $0 }'
  echo | uptime -p | awk '{print "Server uptime: " $0 }'
  echo | uptime | awk -F'load average: ' '{print "Load average: " $2}'
  echo | users | awk '{ print "Logged in users: " $0 }'
}

# Print failed logins for Ubuntu and RedHat (+ their derivatives)
print_failed_logins() {
  logins_redhat=/var/log/secure
  logins_ubuntu=/var/log/auth.log
  if [[ -f $logins_redhat ]];
  then
    echo | grep -c 'Failed password' $logins_redhat | awk '{print "There have been " $1 " failed login(s) so far" }'
  elif [[ -f $logins_ubuntu ]];
  then
    echo | grep -c 'Failed password' $logins_ubuntu | awk '{print "There have been " $1 " failed login(s) so far" }'
  fi
}

timestamp=$(date +%F_%H:%M)
output_file=./server_stats_$timestamp
exec 2>&1 1>$output_file
echo
echo "--------------------------------------------------"
echo "Current Server Performance Stats at $timestamp"
echo "--------------------------------------------------"
echo
print_basic_stats
print_process_stats


echo "-------------------------------"
echo "Bonus things!!"
echo "-------------------------------"
print_bonus_info
print_failed_logins
echo

echo "-------------------------------"
echo "Extra Bonus things to print"
echo "-------------------------------"
arr_users=($USER "testuser" "testuser2")
for i in "${arr_users[@]}"
  do
    if id $i >/dev/null 2>&1;
    then
      target_user=$i
      echo | groups $target_user | sed -e "s/$target_user ://" | awk -v target_user=$target_user '{ print target_user " is part of the following groups:"; for (i = 1; i <= NF; i++) {print $i} }'
      echo
    fi
done

exec >/dev/tty
cat $output_file
# exit 0 # this exits out of root too