Launched a t2.micro instance with Debian 12 ami. 8 gib storage

Beginning state
```
root@ip-172-31-93-26:~# lsblk
NAME     MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
xvda     202:0    0    8G  0 disk
├─xvda1  202:1    0  7.9G  0 part /
├─xvda14 202:14   0    3M  0 part
└─xvda15 202:15   0  124M  0 part /boot/efi
```
Install parted
```
sudo apt update
sudo apt install parted
```

Going to split the root partition into multiple (one for "/", "/home" , "/var" and "/tmp")
- https://medium.com/@ahmedmansouri/a-guide-to-partitioning-the-ebs-root-volume-on-your-linux-ec2-instance-6db838218e36
- Stop the instance (source instance)
- Detach the root volume of the source instance (source_vol)
  - In AWS console, in EC2 instance window, go to Storage tab, click into the volume listed under Block Devices. Select Actions > Detach volume
- Create another instance used as a rescue instance in order to manipulate the volumes and the partitions (same AZ, same AMI)
- Create a new EBS volume (target_vol) in same AZ with size at least equal to source_vol (8 gib here)
- Attach both target_vol and source_vol to the rescue instance. Named them /dev/sdb and /dev/sdc respectively
- Connect to rescue instance
- Check the volumes
```
admin@ip-172-31-91-245:~$ lsblk
NAME     MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
xvda     202:0    0    8G  0 disk
├─xvda1  202:1    0  7.9G  0 part /
├─xvda14 202:14   0    3M  0 part
└─xvda15 202:15   0  124M  0 part /boot/efi
xvdb     202:16   0    8G  0 disk
xvdc     202:32   0    8G  0 disk
├─xvdc1  202:33   0  7.9G  0 part
├─xvdc14 202:46   0    3M  0 part
└─xvdc15 202:47   0  124M  0 part
```
 - xvda is the rescue instance root volume
 - xvdb is the target_vol
 - xvdc is the source_vol
```
root@ip-172-31-91-245:~# parted -l
Model: Xen Virtual Block Device (xvd)
Disk /dev/xvdc: 8590MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name  Flags
14      1049kB  4194kB  3146kB                     bios_grub
15      4194kB  134MB   130MB   fat16              boot, esp
 1      134MB   8589MB  8455MB  ext4


Model: Xen Virtual Block Device (xvd)
Disk /dev/xvda: 8590MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name  Flags
14      1049kB  4194kB  3146kB                     bios_grub
15      4194kB  134MB   130MB   fat16              boot, esp
 1      134MB   8589MB  8455MB  ext4


Error: /dev/xvdb: unrecognised disk label
Model: Xen Virtual Block Device (xvd)
Disk /dev/xvdb: 8590MB
Sector size (logical/physical): 512B/512B
Partition Table: unknown
Disk Flags:
```
Want to split the target_vol (dev/xvdb) into the following partitions (don't really know what the first two are):
- bios_grub: 1049kB -> 4194kB
- boot,esp: 4194kB -> 134MB
- "/": 134MB -> 30%
- "/home": 30% -> 50%
- "/var": 50% -> 80%
- "/tmp": 80% -> 100%

Create BIOS boot Partition (GPT record)
```
root@ip-172-31-91-245:~# parted /dev/xvdb
GNU Parted 3.5
Using /dev/xvdb
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) mklabel gpt
(parted) mkpart "BIOS Boot Partition" 1MB 4MB
(parted) set 1 bios_grub on
(parted) p
Model: Xen Virtual Block Device (xvd)
Disk /dev/xvdb: 8590MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name                 Flags
 1      1049kB  4194kB  3146kB               BIOS Boot Partition  bios_grub
```
 - https://www.gnu.org/software/parted/manual/html_node/set.html#index-set for the set flags command

Create EFI System partition
```
#mkpart "EFI System Partition" fat16 4MB 134MB
#set 2 boot on

(parted) mkpart "EFI System Partition" fat16 4MB 134MB
(parted) p
Model: Xen Virtual Block Device (xvd)
Disk /dev/xvdb: 8590MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name                  Flags
 1      1049kB  4194kB  3146kB               BIOS Boot Partition   bios_grub
 2      4194kB  134MB   130MB   fat16        EFI System Partition  msftdata

(parted) set 2 boot on
(parted) p
Model: Xen Virtual Block Device (xvd)
Disk /dev/xvdb: 8590MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name                  Flags
 1      1049kB  4194kB  3146kB               BIOS Boot Partition   bios_grub
 2      4194kB  134MB   130MB   fat16        EFI System Partition  boot, esp
```

Make the other partitions
```
(parted) mkpart root ext4 134MB 30%
(parted) mkpart home ext4 30% 50%
(parted) mkpart var ext4 50% 80%
(parted) mkpart tmp ext4 80% 100%
```
- result:
  ```
  (parted) print
  Model: Xen Virtual Block Device (xvd)
  Disk /dev/xvdb: 8590MB
  Sector size (logical/physical): 512B/512B
  Partition Table: gpt
  Disk Flags:

  Number  Start   End     Size    File system  Name                  Flags
  1      1049kB  4194kB  3146kB               BIOS Boot Partition   bios_grub
  2      4194kB  134MB   130MB   fat16        EFI System Partition  boot, esp
  3      134MB   2577MB  2443MB  ext4         root
  4      2577MB  4295MB  1718MB  ext4         home
  5      4295MB  6872MB  2577MB  ext4         var
  6      6872MB  8589MB  1717MB  ext4         tmp

  (parted) quit
  Information: You may need to update /etc/fstab.
  ```
  ```
  root@ip-172-31-91-245:~# lsblk
  NAME     MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
  xvda     202:0    0    8G  0 disk
  ├─xvda1  202:1    0  7.9G  0 part /
  ├─xvda14 202:14   0    3M  0 part
  └─xvda15 202:15   0  124M  0 part /boot/efi
  xvdb     202:16   0    8G  0 disk
  ├─xvdb1  202:17   0    3M  0 part
  ├─xvdb2  202:18   0  124M  0 part
  ├─xvdb3  202:19   0  2.3G  0 part
  ├─xvdb4  202:20   0  1.6G  0 part
  ├─xvdb5  202:21   0  2.4G  0 part
  └─xvdb6  202:22   0  1.6G  0 part
  xvdc     202:32   0    8G  0 disk
  ├─xvdc1  202:33   0  7.9G  0 part
  ├─xvdc14 202:46   0    3M  0 part
  └─xvdc15 202:47   0  124M  0 part
  ```
Format the new partitions
```
mkfs.ext4 /dev/xvdb3
mkfs.ext4 /dev/xvdb4
mkfs.ext4 /dev/xvdb5
mkfs.ext4 /dev/xvdb6

root@ip-172-31-91-245:~# mkfs.ext4 /dev/xvdb3
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 596480 4k blocks and 149264 inodes
Filesystem UUID: 25942ee0-91f1-460f-89cc-5ed70977c338
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```
- Result:
  ```
  root@ip-172-31-91-245:~# lsblk -f
  NAME     FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
  xvda
  ├─xvda1  ext4   1.0         41a594d8-90dd-4952-ac44-0e3a5b1540c6    6.2G    13% /
  ├─xvda14
  └─xvda15 vfat   FAT16       71C3-31D2                             112.2M     9% /boot/efi
  xvdb
  ├─xvdb1
  ├─xvdb2
  ├─xvdb3  ext4   1.0         25942ee0-91f1-460f-89cc-5ed70977c338
  ├─xvdb4  ext4   1.0         a8647f5f-cc3a-4371-94c0-81641d9e1b32
  ├─xvdb5  ext4   1.0         1849ca7d-1c70-4f86-8fbf-2ef0371e5cde
  └─xvdb6  ext4   1.0         cd914782-4c75-4c1d-91d1-fb3c76240ca4
  xvdc
  ├─xvdc1  ext4   1.0         41a594d8-90dd-4952-ac44-0e3a5b1540c6
  ├─xvdc14
  └─xvdc15 vfat   FAT16       71C3-31D2
  ```
Mount the partitions
- Need to create the directories where source_vol and the new partitions will be mounted
- Create a directory to mount the source_vol
  ```
  mkdir /mnt/source_vol
  ```
- Create the following directories in order to mount the new partitions
  ```
  mkdir /mnt/target_vol/
  mkdir /mnt/target_vol/root
  mkdir /mnt/target_vol/home
  mkdir /mnt/target_vol/var
  mkdir /mnt/target_vol/tmp
  ```
  - Result (had to `apt install tree` first)
  ```
  root@ip-172-31-91-245:~# tree /mnt
  /mnt
  ├── source_vol
  └── target_vol
      ├── home
      ├── root
      ├── tmp
      └── var

  7 directories, 0 files
  ```
- Mount the source_vol under `/mnt/source_vol` and all other partitions under the appropriate `/mnt/target_vol` directory
  ```
  mount /dev/xvdc1 /mnt/source_vol/
  mount /dev/xvdb3 /mnt/target_vol/root/
  mount /dev/xvdb4 /mnt/target_vol/home/
  mount /dev/xvdb5 /mnt/target_vol/var/
  mount /dev/xvdb6 /mnt/target_vol/tmp/
  ```
  - Using ext4 so don't need the -o nouuid option for xfs filesystems https://serverfault.com/questions/948408/mount-wrong-fs-type-bad-option-bad-superblock-on-dev-xvdf1-missing-codepage
  - Result:
  ```
  root@ip-172-31-91-245:~# lsblk -f
  NAME     FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
  xvda
  ├─xvda1  ext4   1.0         41a594d8-90dd-4952-ac44-0e3a5b1540c6    6.2G    13% /
  ├─xvda14
  └─xvda15 vfat   FAT16       71C3-31D2                             112.2M     9% /boot/efi
  xvdb
  ├─xvdb1
  ├─xvdb2
  ├─xvdb3  ext4   1.0         25942ee0-91f1-460f-89cc-5ed70977c338      2G     0% /mnt/target_vol/root
  ├─xvdb4  ext4   1.0         a8647f5f-cc3a-4371-94c0-81641d9e1b32    1.4G     0% /mnt/target_vol/home
  ├─xvdb5  ext4   1.0         1849ca7d-1c70-4f86-8fbf-2ef0371e5cde    2.2G     0% /mnt/target_vol/var
  └─xvdb6  ext4   1.0         cd914782-4c75-4c1d-91d1-fb3c76240ca4    1.4G     0% /mnt/target_vol/tmp
  xvdc
  ├─xvdc1  ext4   1.0         41a594d8-90dd-4952-ac44-0e3a5b1540c6    6.2G    13% /mnt/source_vol
  ├─xvdc14
  └─xvdc15 vfat   FAT16       71C3-31D2
  ```

Synchronize the "source_vol" volume content into the appropriate new partitions
- Start with non root partitions (`apt install rsync` first)
  ```
  rsync -av /mnt/source_vol/home/ /mnt/target_vol/home/
  rsync -av /mnt/source_vol/var/ /mnt/target_vol/var/
  rsync -av /mnt/source_vol/tmp/ /mnt/target_vol/tmp/

  root@ip-172-31-91-245:~# rsync -av /mnt/source_vol/home/ /mnt/target_vol/home/
  sending incremental file list
  ./
  admin/
  admin/.bash_history
  admin/.bash_logout
  admin/.bashrc
  admin/.profile
  admin/.sudo_as_admin_successful
  admin/.ssh/
  admin/.ssh/authorized_keys

  sent 5,533 bytes  received 145 bytes  11,356.00 bytes/sec
  total size is 4,967  speedup is 0.87
  ```
  - https://www.geeksforgeeks.org/rsync-command-in-linux-with-examples/
- Now, we need to exclude the partitions above when synchronising the "/" partition
  ```
  rsync -av --exclude=home --exclude=var --exclude=tmp /mnt/source_vol/ /mnt/target_vol/root/
  ```
- Check the `/mnt/target_vol/root`
  ```
  root@ip-172-31-91-245:~# ls -la /mnt/target_vol/root/
  total 72
  drwxr-xr-x 15 root root  4096 Jan 10 17:38 .
  drwxr-xr-x  6 root root  4096 Jan 10 18:58 ..
  lrwxrwxrwx  1 root root     7 Jul 17 04:23 bin -> usr/bin
  drwxr-xr-x  4 root root  4096 Jul 17 04:26 boot
  drwxr-xr-x  2 root root  4096 Jul 17 04:26 dev
  drwxr-xr-x 64 root root  4096 Jan 10 17:58 etc
  lrwxrwxrwx  1 root root     7 Jul 17 04:23 lib -> usr/lib
  lrwxrwxrwx  1 root root     9 Jul 17 04:23 lib64 -> usr/lib64
  drwx------  2 root root 16384 Jul 17 04:22 lost+found
  drwxr-xr-x  2 root root  4096 Jul 17 04:23 media
  drwxr-xr-x  2 root root  4096 Jul 17 04:23 mnt
  drwxr-xr-x  2 root root  4096 Jul 17 04:23 opt
  drwxr-xr-x  2 root root  4096 Mar 29  2024 proc
  drwx------  3 root root  4096 Jul 17 04:24 root
  drwxr-xr-x  2 root root  4096 Jul 17 04:26 run
  lrwxrwxrwx  1 root root     8 Jul 17 04:23 sbin -> usr/sbin
  drwxr-xr-x  2 root root  4096 Jul 17 04:23 srv
  drwxr-xr-x  2 root root  4096 Mar 29  2024 sys
  drwxr-xr-x 12 root root  4096 Jul 17 04:23 usr
  ```
- `/root/home`, `/root/var`, and `/root/tmp` are missing. Create them and update permissions
  ```
  mkdir /mnt/target_vol/root/home
  mkdir /mnt/target_vol/root/var
  mkdir /mnt/target_vol/root/tmp

  chmod 755 /mnt/target_vol/root/home
  chmod 755 /mnt/target_vol/root/var
  chmod 777 /mnt/target_vol/root/tmp
  ```
- Unmount the source_vol and mount the non root paritions under /mnt/target_vol/root/
  ```
  umount /mnt/source_vol

  umount /mnt/target_vol/home/
  umount /mnt/target_vol/var/
  umount /mnt/target_vol/tmp/

  mount /dev/xvdb4 /mnt/target_vol/root/home/
  mount /dev/xvdb5 /mnt/target_vol/root/var/
  mount /dev/xvdb6 /mnt/target_vol/root/tmp/
  ```
  - Before and after
    ```
    #before
    root@ip-172-31-91-245:~# lsblk
    NAME     MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
    xvda     202:0    0    8G  0 disk
    ├─xvda1  202:1    0  7.9G  0 part /
    ├─xvda14 202:14   0    3M  0 part
    └─xvda15 202:15   0  124M  0 part /boot/efi
    xvdb     202:16   0    8G  0 disk
    ├─xvdb1  202:17   0    3M  0 part
    ├─xvdb2  202:18   0  124M  0 part
    ├─xvdb3  202:19   0  2.3G  0 part /mnt/target_vol/root
    ├─xvdb4  202:20   0  1.6G  0 part /mnt/target_vol/home
    ├─xvdb5  202:21   0  2.4G  0 part /mnt/target_vol/var
    └─xvdb6  202:22   0  1.6G  0 part /mnt/target_vol/tmp
    xvdc     202:32   0    8G  0 disk
    ├─xvdc1  202:33   0  7.9G  0 part /mnt/source_vol
    ├─xvdc14 202:46   0    3M  0 part
    └─xvdc15 202:47   0  124M  0 part

    # after
    root@ip-172-31-91-245:~# lsblk
    NAME     MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
    xvda     202:0    0    8G  0 disk
    ├─xvda1  202:1    0  7.9G  0 part /
    ├─xvda14 202:14   0    3M  0 part
    └─xvda15 202:15   0  124M  0 part /boot/efi
    xvdb     202:16   0    8G  0 disk
    ├─xvdb1  202:17   0    3M  0 part
    ├─xvdb2  202:18   0  124M  0 part
    ├─xvdb3  202:19   0  2.3G  0 part /mnt/target_vol/root
    ├─xvdb4  202:20   0  1.6G  0 part /mnt/target_vol/root/home
    ├─xvdb5  202:21   0  2.4G  0 part /mnt/target_vol/root/var
    └─xvdb6  202:22   0  1.6G  0 part /mnt/target_vol/root/tmp
    xvdc     202:32   0    8G  0 disk
    ├─xvdc1  202:33   0  7.9G  0 part
    ├─xvdc14 202:46   0    3M  0 part
    └─xvdc15 202:47   0  124M  0 part
    ```

Install GRUB on the new volume “target_vol” (Idk waht is happening)
```
for m in dev proc run sys; do mount -o bind {,/mnt/target_vol/root}/$m; done
chroot /mnt/target_vol/root
```
- Move old grub config `mv /boot/grub/grub.cfg /boot/grub/grub.cfg.org`
- Install grub boot loader in target_vol `grub-install /dev/xvdb`
- Regenerate GRUB config file: `grub-mkconfig -o /boot/grub/grub.cfg`

*!! I wonder if something needs to be done for EFI thing too?*

Edit “/etc/fstab” file and set new partitions
- Backup old file: `cp /etc/fstab /etc/fstab.org`
- Add the new partitions to the/etc/fstab file based on the UUIDs given by the lsblk -f output
```
root@ip-172-31-91-245:/# lsblk -f
NAME     FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
xvda
├─xvda1  ext4   1.0         41a594d8-90dd-4952-ac44-0e3a5b1540c6
├─xvda14
└─xvda15 vfat   FAT16       71C3-31D2
xvdb
├─xvdb1
├─xvdb2
├─xvdb3  ext4   1.0         25942ee0-91f1-460f-89cc-5ed70977c338    1.3G    36% /
├─xvdb4  ext4   1.0         a8647f5f-cc3a-4371-94c0-81641d9e1b32    1.4G     0% /home
├─xvdb5  ext4   1.0         1849ca7d-1c70-4f86-8fbf-2ef0371e5cde    1.9G    11% /var
└─xvdb6  ext4   1.0         cd914782-4c75-4c1d-91d1-fb3c76240ca4    1.4G     0% /tmp
xvdc
├─xvdc1  ext4   1.0         41a594d8-90dd-4952-ac44-0e3a5b1540c6
├─xvdc14
└─xvdc15 vfat   FAT16       71C3-31D2
```
```
# /etc/fstab

UUID=25942ee0-91f1-460f-89cc-5ed70977c338 /  ext4   defaults 0  0
UUID=a8647f5f-cc3a-4371-94c0-81641d9e1b32 /home ext4 defaults 0 0
UUID=1849ca7d-1c70-4f86-8fbf-2ef0371e5cde /var ext4 defaults 0 0
UUID=cd914782-4c75-4c1d-91d1-fb3c76240ca4 /tmp ext4 defaults 0 0
```

Unmount the volume target_vol and its partitions and attach it to the source instance
```
umount /mnt/target_vol/root/{dev,proc,run,sys,home,var,tmp,}

root@ip-172-31-91-245:/# umount /mnt/target_vol/root/{dev,proc,run,sys,home,var,tmp,}
umount: /mnt/target_vol/root/dev: no mount point specified.
umount: /mnt/target_vol/root/proc: no mount point specified.
umount: /mnt/target_vol/root/run: no mount point specified.
umount: /mnt/target_vol/root/sys: no mount point specified.
umount: /mnt/target_vol/root/home: no mount point specified.
umount: /mnt/target_vol/root/var: no mount point specified.
umount: /mnt/target_vol/root/tmp: no mount point specified.
umount: /mnt/target_vol/root/: no mount point specified.
```
- In aws console, detach the target volume from rescue instance and attach it to the source instance (as the root volume)
- Start the source instance
- Check the partitions
  ```
  admin@ip-172-31-93-26:~$ lsblk -f
  NAME    FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
  xvda
  ├─xvda1
  ├─xvda2
  ├─xvda3 ext4   1.0         25942ee0-91f1-460f-89cc-5ed70977c338    1.3G    36% /
  ├─xvda4 ext4   1.0         a8647f5f-cc3a-4371-94c0-81641d9e1b32    1.4G     0% /home
  ├─xvda5 ext4   1.0         1849ca7d-1c70-4f86-8fbf-2ef0371e5cde    1.9G    11% /var
  └─xvda6 ext4   1.0         cd914782-4c75-4c1d-91d1-fb3c76240ca4    1.4G     0% /tmp


  admin@ip-172-31-93-26:~$ sudo parted
  GNU Parted 3.5
  Using /dev/xvda
  Welcome to GNU Parted! Type 'help' to view a list of commands.
  (parted) print
  Model: Xen Virtual Block Device (xvd)
  Disk /dev/xvda: 8590MB
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
  ```