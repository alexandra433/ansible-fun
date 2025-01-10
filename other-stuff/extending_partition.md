First, partition the ec2 instance so that there is actually something to extend

Then create a snapshot of that volume because there's too many steps

**Extending a partition**
---------------------------------
Going to increase size of hard disk and extend the partition for /tmp
**Increase disk space**
AWS console > click into the volume > modify > change size from 8 to 9 GiB
- Once volume state is optimizing, can start messing around
```
root@ip-172-31-93-26:~# parted
GNU Parted 3.5
Using /dev/xvda
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) print
Warning: Not all of the space available to /dev/xvda appears to be used, you can fix the GPT to use all of the space
(an extra 2097152 blocks) or continue with the current setting?
Fix/Ignore? ignore
Model: Xen Virtual Block Device (xvd)
Disk /dev/xvda: 9664MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name                  Flags
 1      1049kB  4194kB  3146kB               BIOS Boot Partition   bios_grub
 2      4194kB  134MB   130MB                EFI System Partition  boot, esp
 3      134MB   2577MB  2443MB  ext4         root
 4      2577MB  4295MB  1718MB  ext4         home
 5      4295MB  6872MB  2577MB  ext4         var
 6      6872MB  8589MB  1717MB  ext4         tmp

(parted)
```
**Increase /tmp**
current size:
```
root@ip-172-31-93-26:~# df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            475M     0  475M   0% /dev
tmpfs            98M  492K   97M   1% /run
/dev/xvda3      2.2G  798M  1.3G  39% /
tmpfs           486M     0  486M   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
/dev/xvda4      1.6G   52K  1.5G   1% /home
/dev/xvda6      1.6G   48K  1.5G   1% /tmp
/dev/xvda5      2.3G  251M  2.0G  12% /var
tmpfs            98M     0   98M   0% /run/user/1000
```
Resizing
```
root@ip-172-31-93-26:~# parted
GNU Parted 3.5
Using /dev/xvda
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) print
Warning: Not all of the space available to /dev/xvda appears to be used, you can fix the GPT to use all of the space
(an extra 2097152 blocks) or continue with the current setting?
Fix/Ignore? fix
Model: Xen Virtual Block Device (xvd)
Disk /dev/xvda: 9664MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name                  Flags
 1      1049kB  4194kB  3146kB               BIOS Boot Partition   bios_grub
 2      4194kB  134MB   130MB                EFI System Partition  boot, esp
 3      134MB   2577MB  2443MB  ext4         root
 4      2577MB  4295MB  1718MB  ext4         home
 5      4295MB  6872MB  2577MB  ext4         var
 6      6872MB  8589MB  1717MB  ext4         tmp

(parted) resizepart 6
Warning: Partition /dev/xvda6 is being used. Are you sure you want to continue?
Yes/No? yes
End?  [8589MB]? -1
(parted) print
Model: Xen Virtual Block Device (xvd)
Disk /dev/xvda: 9664MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name                  Flags
 1      1049kB  4194kB  3146kB               BIOS Boot Partition   bios_grub
 2      4194kB  134MB   130MB                EFI System Partition  boot, esp
 3      134MB   2577MB  2443MB  ext4         root
 4      2577MB  4295MB  1718MB  ext4         home
 5      4295MB  6872MB  2577MB  ext4         var
 6      6872MB  9663MB  2790MB  ext4         tmp

(parted) q
Information: You may need to update /etc/fstab.
```
- Don't think you need to update `/etc/fstab` because the uuid number for `/tmp` (check with `lsblk -f`) still matches what's in the file


