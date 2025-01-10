**Creating Increasing swap space**
-------------------------------
Installed lvm2 but probably won't use it for this: `apt install lvm2`

***Using a swapfile***

- https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-debian-11
Check if system already has swap available:
```
root@ip-172-31-93-26:~# swapon --show
root@ip-172-31-93-26:~#
```
 - No output, means no swap space available currently
Can verify with `free -h`
```
root@ip-172-31-93-26:~# free -h
               total        used        free      shared  buff/cache   available
Mem:           970Mi       227Mi       560Mi       496Ki       319Mi       742Mi
Swap:             0B          0B          0B
```
Creating swap file in root directory
- most common place to create swap file
- current disk usage
 ```
  df -h
  Filesystem      Size  Used Avail Use% Mounted on
  udev            472M     0  472M   0% /dev
  tmpfs            98M  500K   97M   1% /run
  /dev/xvda3      2.2G  811M  1.3G  39% /
  tmpfs           486M     0  486M   0% /dev/shm
  tmpfs           5.0M     0  5.0M   0% /run/lock
  /dev/xvda4      1.6G   52K  1.5G   1% /home
  /dev/xvda6      2.6G   48K  2.4G   1% /tmp
  /dev/xvda5      2.3G  252M  2.0G  12% /var
  tmpfs            98M     0   98M   0% /run/user/1000
 ```
- can use `fallocate` program to create a file of a specified size
- `fallocate -l 0.01G /swapfile` (10M just because)
Enable swap file:
- Make only accessible to root first `chmod 600 /swapfile`
- Mark the file as swap space `mkswap /swapfile`
  ```
  root@ip-172-31-93-26:~# mkswap /swapfile
  Setting up swapspace version 1, size = 10.2 MiB (10731520 bytes)
  no label, UUID=c9081841-f0fb-43cf-ac8a-2751c81a8906
  ```
- Enable the swap file: `swapon /swapfile`
- Verify swap is available `swapon --show`
  ```
  root@ip-172-31-93-26:~# swapon --show
  NAME      TYPE  SIZE USED PRIO
  /swapfile file 10.2M   0B   -2
  root@ip-172-31-93-26:~# free -h
                total        used        free      shared  buff/cache   available
  Mem:           970Mi       215Mi       598Mi       500Ki       292Mi       754Mi
  Swap:           10Mi          0B        10Mi
  ```
Make swap file permanent by adding it to /etc/fstab
- Back up file just in case `cp /etc/fstab /etc/fstab.bak`
- Add swap file info to end of `/etc/fstab`: `echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab`