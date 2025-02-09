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
- Top 5 processes by CPU usage
- Top 5 processes by memory usage
- OS version
- uptime
- load average
- logged in users
- failed login attempts
- print the each group in the output of the `groups` command on its own line
  - `groups | awk '{ print $USER " is part of the following groups"; for (i = 1; i <= NF; i++) {print $i} }'`

**Stuff**
- https://stackoverflow.com/questions/17066250/create-timestamp-variable-in-bash-script