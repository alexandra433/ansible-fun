Seeing what happens if you set up log rotation with a max size and the specified log is already at that max size

- created a random "log" file
  - `mkdir /var/log/testing`
  - `head -c 262144003  </dev/urandom > /var/log/testing/testlog`
- create the log rotate config file
  - `nano /etc/logrotate.d/testrotate`
  - https://betterstack.com/community/guides/logging/how-to-manage-log-files-with-logrotate-on-ubuntu-20-04/
```
/var/log/testing/testlog {
  rotate 3
  copytruncates
  weekly
  missingok
  notifempty
  compress
  maxsize 250M
}
```
  - 250M = 262144000 bytes

- testing
  - `cat /var/lib/logrotate/status`
  - `logrotate /etc/logrotate.d/testrotate --debug`
  - `logrotate /etc/logrotate.d --debug`