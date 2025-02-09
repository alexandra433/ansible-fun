**Requirements**
----------------------
- https://roadmap.sh/projects/server-stats
- Write a bash script that can analyze basic server performance stats on any Linux server
  - Total CPU usage
  - Total memory usage (free vs used)
  - Total disk usage (free vs used)
  - Top 5 processes by CPU usage
  - Top 5 processes by memory usage
  - Bonus:
    - OS version
    - uptime
    - load average
    - logged in users
    - failed login attempts
  - Extra extra bouns
    - print the each group in the output of the `groups` command on its own line
    - Save output of script to a file

**Commands**
- Total CPU usage
  - percentage of time a CPU takes to process non-idle tasks
  - Calculate by taking the percentage of time spent idling (divided over number of cores) and subtracting it from 100
    - 100 - (idle time / CPU cores)
  - Using the `top` command (https://www.baeldung.com/linux/get-cpu-usage)
    - `top -bn2 | grep '%Cpu' | tail -1 | grep -P '(....|...) id,'|awk '{print "CPU Usage: " 100-$8 "%"}'`
      - Instance I'm using has 1 core. Will need to get number os cores in script
      - `top -bn2`: `-n` specifies the number of iterations the `top command should use before ending. Avoid using the first iteration because those values are the values since boot
      ```
      [root@ip-172-31-90-90 ~]# top -bn2 | grep '%Cpu'
      %Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
      %Cpu(s):  0.0 us,  0.3 sy,  0.0 ni, 99.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.3 st
      ```
- Total memory usage (free vs used)
  - `top -bn2 | grep 'MiB Mem' |top -bn2 | grep 'MiB Mem' | tail -1 | awk '{ printf "Mem usage:"; for (i=4; i<=9; i++) printf " " $i; printf "\n" }'`
- Total disk usage (free vs used)
  - `df -h --total | tail -1 | awk '{ print "Disk usage: " $3 " Used, " $4 " Avaliable (" $5 " usage)"}'`
- Top 5 processes by CPU usage
  - `ps aux --sort -%cpu | head -n 5`
    - `ps aux` lists all running processes
- Top 5 processes by memory usage
  - `ps aux --sort -%mem | head -n 5`
- OS version
  - `grep PRETTY_NAME /etc/os-release | sed -e 's/PRETTY_NAME=//' | awk '{ print "OS version: " $0 }'`
- uptime
  - `uptime -p | awk '{print "Server uptime: " $0 }'`
- load average
  - the amount of computational work a system performs over a period of time
  - `uptime | awk -F'load average: ' '{print $2}'`
    - `-F` specifies what field separater to use
    - `'{print $2}'` means to print the second field (after the separator)
    ```
    [root@ip-172-31-90-90 ~]# uptime
    19:05:36 up  2:58,  1 user,  load average: 0.00, 0.00, 0.00
    [root@ip-172-31-90-90 ~]# uptime | awk -F'load average: ' '{print $2}'
    0.00, 0.00, 0.00
    ```
- logged in users
  - `w`, `who`, and `users` are all possible commands to use
- failed login attempts
  - `/var/log/auth.log` in Ubuntu systems, `/var/log/secure` in Redhat
- print the each group in the output of the `groups` command on its own line
  - `groups | awk '{ print $USER " is part of the following groups"; for (i = 1; i <= NF; i++) {print $i} }'`
- Save output of script to a file

**Stuff**
- https://stackoverflow.com/questions/17066250/create-timestamp-variable-in-bash-script
- https://www.atlantic.net/vps-hosting/find-top-10-running-processes-by-memory-and-cpu-usage/