cd '/c/Users/alexa/OneDrive/Documents/aws/aws saa/ssh key pair'


apt update
apt upgrade
apt install lvm2


Created an 8GB EBS volume in same AZ, attached it to instance

https://starbeamrainbowlabs.com/blog/article.php?article=posts/428-lvm-beginners.html

```
root@ip-172-31-93-39:~# lsblk
NAME     MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
xvda     202:0    0    8G  0 disk
├─xvda1  202:1    0  7.9G  0 part /
├─xvda14 202:14   0    3M  0 part
└─xvda15 202:15   0  124M  0 part /boot/efi
xvdb     202:16   0    8G  0 disk
```
fdisk /dev/xvdb
```
Command (m for help): n
Partition number (1-128, default 1):
First sector (2048-16777182, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-16777182, default 16775167): +500M

Created a new partition 1 of type 'Linux filesystem' and of size 500 MiB.

Command (m for help): n
Partition number (2-128, default 2): 2
First sector (1026048-16777182, default 1026048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (1026048-16777182, default 16775167): +500M

Created a new partition 2 of type 'Linux filesystem' and of size 500 MiB.

Command (m for help): n
Partition number (3-128, default 3): 3
First sector (2050048-16777182, default 2050048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2050048-16777182, default 16775167): +3G

Created a new partition 3 of type 'Linux filesystem' and of size 3 GiB.

Command (m for help): t
Partition number (1-3, default 3): 3
Partition type or alias (type L to list all): L
  1 EFI System                     C12A7328-F81F-11D2-BA4B-00A0C93EC93B
  1 EFI System                     C12A7328-F81F-11D2-BA4B-00A0C93EC93B
  2 MBR partition scheme           024DEE41-33E7-11D3-9D69-0008C781F39F
  3 Intel Fast Flash               D3BFE2DE-3DAF-11DF-BA40-E3A556D89593
  4 BIOS boot                      21686148-6449-6E6F-744E-656564454649
  5 Sony boot partition            F4019732-066E-4E12-8273-346C5641494F
  6 Lenovo boot partition          BFBFAFE7-A34F-448A-9A5B-6213EB736C22
  7 PowerPC PReP boot              9E1A2D38-C612-4316-AA26-8B49521E5A8B
  8 ONIE boot                      7412F7D5-A156-4B13-81DC-867174929325
  9 ONIE config                    D4E6E2CD-4469-46F3-B5CB-1BFF57AFC149
 10 Microsoft reserved             E3C9E316-0B5C-4DB8-817D-F92DF00215AE
 11 Microsoft basic data           EBD0A0A2-B9E5-4433-87C0-68B6B72699C7
 12 Microsoft LDM metadata         5808C8AA-7E8F-42E0-85D2-E1E90434CFB3
 13 Microsoft LDM data             AF9B60A0-1431-4F62-BC68-3311714A69AD
 14 Windows recovery environment   DE94BBA4-06D1-4D40-A16A-BFD50179D6AC
 15 IBM General Parallel Fs        37AFFC90-EF7D-4E96-91C3-2D7AE055B174
 16 Microsoft Storage Spaces       E75CAF8F-F680-4CEE-AFA3-B001E56EFC2D
 17 HP-UX data                     75894C1E-3AEB-11D3-B7C1-7B03A0000000
 18 HP-UX service                  E2A1E728-32E3-11D6-A682-7B03A0000000
 19 Linux swap                     0657FD6D-A4AB-43C4-84E5-0933C84B4F4F
 20 Linux filesystem               0FC63DAF-8483-4772-8E79-3D69D8477DE4
 21 Linux server data              3B8F8425-20E0-4F3B-907F-1A25A76F98E8
 22 Linux root (x86)               44479540-F297-41B2-9AF7-D131D5F0458A
 23 Linux root (x86-64)            4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709
 24 Linux root (Alpha)             6523F8AE-3EB1-4E2A-A05A-18B695AE656F
 25 Linux root (ARC)               D27F46ED-2919-4CB8-BD25-9531F3C16534
 26 Linux root (ARM)               69DAD710-2CE4-4E3C-B16C-21A1D49ABED3
 27 Linux root (ARM-64)            B921B045-1DF0-41C3-AF44-4C6F280D3FAE
 28 Linux root (IA-64)             993D8D3D-F80E-4225-855A-9DAF8ED7EA97
 29 Linux root (LoongArch-64)      77055800-792C-4F94-B39A-98C91B762BB6
 30 Linux root (MIPS-32 LE)        37C58C8A-D913-4156-A25F-48B1B64E07F0
 31 Linux root (MIPS-64 LE)        700BDA43-7A34-4507-B179-EEB93D7A7CA3
 32 Linux root (PPC)               1DE3F1EF-FA98-47B5-8DCD-4A860A654D78
 33 Linux root (PPC64)             912ADE1D-A839-4913-8964-A10EEE08FBD2
 34 Linux root (PPC64LE)           C31C45E6-3F39-412E-80FB-4809C4980599
 35 Linux root (RISC-V-32)         60D5A7FE-8E7D-435C-B714-3DD8162144E1
 36 Linux root (RISC-V-64)         72EC70A6-CF74-40E6-BD49-4BDA08E8F224
 37 Linux root (S390)              08A7ACEA-624C-4A20-91E8-6E0FA67D23F9
 38 Linux root (S390X)             5EEAD9A9-FE09-4A1E-A1D7-520D00531306
 39 Linux root (TILE-Gx)           C50CDD70-3862-4CC3-90E1-809A8C93EE2C
 40 Linux reserved                 8DA63339-0007-60C0-C436-083AC8230908
 41 Linux home                     933AC7E1-2EB4-4F13-B844-0E14E2AEF915
 42 Linux RAID                     A19D880F-05FC-4D3B-A006-743F0F84911E
 43 Linux LVM                      E6D6D379-F507-44C2-A23C-238F2A3DF928
 44 Linux variable data            4D21B016-B534-45C2-A9FB-5C16E091FD2D
 45 Linux temporary data           7EC6F557-3BC5-4ACA-B293-16EF5DF639D1
 28 Linux root (IA-64)             993D8D3D-F80E-4225-855A-9DAF8ED7EA97
 29 Linux root (LoongArch-64)      77055800-792C-4F94-B39A-98C91B762BB6
 30 Linux root (MIPS-32 LE)        37C58C8A-D913-4156-A25F-48B1B64E07F0
 31 Linux root (MIPS-64 LE)        700BDA43-7A34-4507-B179-EEB93D7A7CA3
 32 Linux root (PPC)               1DE3F1EF-FA98-47B5-8DCD-4A860A654D78
 33 Linux root (PPC64)             912ADE1D-A839-4913-8964-A10EEE08FBD2
 34 Linux root (PPC64LE)           C31C45E6-3F39-412E-80FB-4809C4980599
 35 Linux root (RISC-V-32)         60D5A7FE-8E7D-435C-B714-3DD8162144E1
 36 Linux root (RISC-V-64)         72EC70A6-CF74-40E6-BD49-4BDA08E8F224
 37 Linux root (S390)              08A7ACEA-624C-4A20-91E8-6E0FA67D23F9
 38 Linux root (S390X)             5EEAD9A9-FE09-4A1E-A1D7-520D00531306
 39 Linux root (TILE-Gx)           C50CDD70-3862-4CC3-90E1-809A8C93EE2C
 40 Linux reserved                 8DA63339-0007-60C0-C436-083AC8230908
 41 Linux home                     933AC7E1-2EB4-4F13-B844-0E14E2AEF915
 42 Linux RAID                     A19D880F-05FC-4D3B-A006-743F0F84911E
 43 Linux LVM                      E6D6D379-F507-44C2-A23C-238F2A3DF928
 44 Linux variable data            4D21B016-B534-45C2-A9FB-5C16E091FD2D
 45 Linux temporary data           7EC6F557-3BC5-4ACA-B293-16EF5DF639D1
 46 Linux /usr (x86)               75250D76-8CC6-458E-BD66-BD47CC81A812
 47 Linux /usr (x86-64)            8484680C-9521-48C6-9C11-B0720656F69E
 48 Linux /usr (Alpha)             E18CF08C-33EC-4C0D-8246-C6C6FB3DA024
 49 Linux /usr (ARC)               7978A683-6316-4922-BBEE-38BFF5A2FECC
 50 Linux /usr (ARM)               7D0359A3-02B3-4F0A-865C-654403E70625
Partition type or alias (type L to list all): 43

Changed type of partition 'Linux filesystem' to 'Linux LVM'.

Command (m for help): n
Partition number (4-128, default 4): 4
First sector (8341504-16777182, default 8341504):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (8341504-16777182, default 16775167):

Created a new partition 4 of type 'Linux filesystem' and of size 4 GiB.

Command (m for help): t
Partition number (1-4, default 4): 4
Partition type or alias (type L to list all): 43

Changed type of partition 'Linux filesystem' to 'Linux LVM'.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
root@ip-172-31-93-39:~# lsblk
NAME     MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
xvda     202:0    0    8G  0 disk
├─xvda1  202:1    0  7.9G  0 part /
├─xvda14 202:14   0    3M  0 part
└─xvda15 202:15   0  124M  0 part /boot/efi
xvdb     202:16   0    8G  0 disk
├─xvdb1  202:17   0  500M  0 part
├─xvdb2  202:18   0  500M  0 part
├─xvdb3  202:19   0    3G  0 part
└─xvdb4  202:20   0    4G  0 part
```

```
root@ip-172-31-93-39:~# fdisk -l
Disk /dev/xvda: 8 GiB, 8589934592 bytes, 16777216 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 3E30AB38-DA4A-9343-A909-646A2B454ADB

Device       Start      End  Sectors  Size Type
/dev/xvda1  262144 16775167 16513024  7.9G Linux root (x86-64)
/dev/xvda14   2048     8191     6144    3M BIOS boot
/dev/xvda15   8192   262143   253952  124M EFI System

Partition table entries are not in disk order.


Disk /dev/xvdb: 8 GiB, 8589934592 bytes, 16777216 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: F31C352D-7E8A-0745-9CC0-C9613E28DCCB

Device       Start      End Sectors  Size Type
/dev/xvdb1    2048  1026047 1024000  500M Linux filesystem
/dev/xvdb2 1026048  2050047 1024000  500M Linux filesystem
/dev/xvdb3 2050048  8341503 6291456    3G Linux LVM
/dev/xvdb4 8341504 16775167 8433664    4G Linux LVM
root@ip-172-31-93-39:~# pvcreate /dev/xvdb3
  Physical volume "/dev/xvdb3" successfully created.
root@ip-172-31-93-39:~# pvcreate /dev/xvdb4
  Physical volume "/dev/xvdb4" successfully created.
root@ip-172-31-93-39:~# vgcreate vg01
  No command with matching syntax recognised.  Run 'vgcreate --help' for more information.
  Correct command syntax is:
  vgcreate VG_new PV ...

root@ip-172-31-93-39:~# vgcreate vg01 /dev/xvdb3 /dev/xvdb4
  Volume group "vg01" successfully created
```

https://medium.com/@ahmedmansouri/a-guide-to-partitioning-the-ebs-root-volume-on-your-linux-ec2-instance-6db838218e36

Creating lv for:
/var
/var/log
/home
/tmp

```
lvcreate -L 2G -n lvm_var vg01
lvcreate -L 2G -n lvm_var_log vg01
lvcreate -L 3G -n lvm_home vg01
lvcreate -L 1G -n lvm_tmp vg01 # vg01 wasn't big enough
```

```
root@ip-172-31-93-39:~# lvcreate -L 2G -n lvm_var vg01
  Logical volume "lvm_var" created.
root@ip-172-31-93-39:~# lvcreate -L 2G -n lvm_var_log vg01
  Logical volume "lvm_var_log" created.
root@ip-172-31-93-39:~# lvcreate -L 3G -n lvm_home vg01
  Logical volume "lvm_home" created.
root@ip-172-31-93-39:~# lvcreate -L 1G -n lvm_tmp vg01
  Volume group "vg01" has insufficient free space (4 extents): 256 required.
root@ip-172-31-93-39:~# lvcreate -l 100%FREE -n lvm_tmp vg01
  Logical volume "lvm_tmp" created.

root@ip-172-31-93-39:~# lvdisplay
  --- Logical volume ---
  LV Path                /dev/vg01/lvm_var
  LV Name                lvm_var
  VG Name                vg01
  LV UUID                cJIreO-TDFM-opE7-ahuE-DGju-xrF9-ohm56Y
  LV Write Access        read/write
  LV Creation host, time ip-172-31-93-39, 2025-05-19 23:39:48 +0000
  LV Status              available
  # open                 0
  LV Size                2.00 GiB
  Current LE             512
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:0

  --- Logical volume ---
  LV Path                /dev/vg01/lvm_var_log
  LV Name                lvm_var_log
  VG Name                vg01
  LV UUID                jHFfXp-80RX-67ox-zr9V-J8uQ-Y0Ad-1bjFy3
  LV Write Access        read/write
  LV Creation host, time ip-172-31-93-39, 2025-05-19 23:39:55 +0000
  LV Status              available
  # open                 0
  LV Size                2.00 GiB
  Current LE             512
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:1

  --- Logical volume ---
  LV Path                /dev/vg01/lvm_home
  LV Name                lvm_home
  VG Name                vg01
  LV UUID                NXmoD1-kMaH-kYnR-fO63-Djx0-Sa4o-gyFmXi
  LV Write Access        read/write
  LV Creation host, time ip-172-31-93-39, 2025-05-19 23:40:01 +0000
  LV Status              available
  # open                 0
  LV Size                3.00 GiB
  Current LE             768
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:2

  --- Logical volume ---
  LV Path                /dev/vg01/lvm_tmp
  LV Name                lvm_tmp
  VG Name                vg01
  LV UUID                SG1Ii1-BdsB-Eb1d-I5J3-yYDl-9V1c-7cJcu0
  LV Write Access        read/write
  LV Creation host, time ip-172-31-93-39, 2025-05-19 23:40:41 +0000
  LV Status              available
  # open                 0
  LV Size                16.00 MiB
  Current LE             4
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:3
root@ip-172-31-93-39:~# lvscan
  ACTIVE            '/dev/vg01/lvm_var' [2.00 GiB] inherit
  ACTIVE            '/dev/vg01/lvm_var_log' [2.00 GiB] inherit
  ACTIVE            '/dev/vg01/lvm_home' [3.00 GiB] inherit
  ACTIVE            '/dev/vg01/lvm_tmp' [16.00 MiB] inherit
root@ip-172-31-93-39:~# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
xvda                 202:0    0    8G  0 disk
├─xvda1              202:1    0  7.9G  0 part /
├─xvda14             202:14   0    3M  0 part
└─xvda15             202:15   0  124M  0 part /boot/efi
xvdb                 202:16   0    8G  0 disk
├─xvdb1              202:17   0  500M  0 part
├─xvdb2              202:18   0  500M  0 part
├─xvdb3              202:19   0    3G  0 part
│ ├─vg01-lvm_var     254:0    0    2G  0 lvm
│ ├─vg01-lvm_home    254:2    0    3G  0 lvm
│ └─vg01-lvm_tmp     254:3    0   16M  0 lvm
└─xvdb4              202:20   0    4G  0 part
  ├─vg01-lvm_var_log 254:1    0    2G  0 lvm
  └─vg01-lvm_home    254:2    0    3G  0 lvm
```

Make filesystems (doing ext4 because that's what the other ones are)
-------------------------
```
mkfs.ext4 /dev/vg01/lvm_var
mkfs.ext4 /dev/vg01/lvm_var_log
mkfs.ext4 /dev/vg01/lvm_tmp
mkfs.ext4 /dev/vg01/lvm_home
```

```
root@ip-172-31-93-39:~# lvs
  LV          VG   Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lvm_home    vg01 -wi-a-----  3.00g                                            
  lvm_tmp     vg01 -wi-a----- 16.00m                                            
  lvm_var     vg01 -wi-a-----  2.00g                                            
  lvm_var_log vg01 -wi-a-----  2.00g                                            
root@ip-172-31-93-39:~# mkfs.ext4 /dev/vg01/lvm_var
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 524288 4k blocks and 131072 inodes
Filesystem UUID: d10e4ee6-2d7c-4642-8867-b891320eb26e
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

root@ip-172-31-93-39:~#
```

mounting the partitions
--------------------------
```
mkdir /mnt/home
mount /dev/vg01/lvm_home /mnt/home
mkdir /mnt/var
mount /dev/vg01/lvm_var /mnt/var
mkdir /mnt/var/log
mount /dev/vg01/lvm_var_log /mnt/var/log
mkdir /mnt/tmp
mount /dev/vg01/lvm_tmp /mnt/tmp
```

```
root@ip-172-31-93-39:~# mkdir /mnt/home
root@ip-172-31-93-39:~# mount /dev/vg01/lvm_home /mnt/home
root@ip-172-31-93-39:~# df -h
Filesystem                 Size  Used Avail Use% Mounted on
udev                       475M     0  475M   0% /dev
tmpfs                       98M  532K   97M   1% /run
/dev/xvda1                 7.7G  1.2G  6.1G  17% /
tmpfs                      486M     0  486M   0% /dev/shm
tmpfs                      5.0M     0  5.0M   0% /run/lock
/dev/xvda15                124M   12M  113M  10% /boot/efi
tmpfs                       98M     0   98M   0% /run/user/1000
/dev/mapper/vg01-lvm_home  2.9G   24K  2.8G   1% /mnt/home


root@ip-172-31-93-39:~# df -h
Filesystem                    Size  Used Avail Use% Mounted on
udev                          475M     0  475M   0% /dev
tmpfs                          98M  532K   97M   1% /run
/dev/xvda1                    7.7G  1.2G  6.1G  17% /
tmpfs                         486M     0  486M   0% /dev/shm
tmpfs                         5.0M     0  5.0M   0% /run/lock
/dev/xvda15                   124M   12M  113M  10% /boot/efi
tmpfs                          98M     0   98M   0% /run/user/1000
/dev/mapper/vg01-lvm_home     2.9G   24K  2.8G   1% /mnt/home
/dev/mapper/vg01-lvm_var      2.0G   28K  1.8G   1% /mnt/var
/dev/mapper/vg01-lvm_var_log  2.0G   24K  1.8G   1% /mnt/var/log
/dev/mapper/vg01-lvm_tmp       14M   14K   13M   1% /mnt/tmp
```


Moving existing folders to another partition
-------------------------------
https://serverfault.com/questions/429937/how-to-move-var-to-another-existing-partition


```
rsync -raX /var/ /mnt/var/
```
- -r recurse into directories
- -a archive (preserve timestamps, ownership, modes, etc)
- -X preserve extended attributes like security labels used by apparmor and selinux

Creating some files in /home first
```
mkdir /home/fun
touch /home/fun/stupid.sh
chmod 777 /home/fun/stupid.sh
echo "What about it?" > /home/fun/testing.txt
chown root:root /home/fun/testing.txt
```

Moving stuff over with rsync
---------------------------
```
apt install rsync
rsync -raX /var/ /mnt/var/
rsync -raX /var/log/ /mnt/var/log/
rsync -raX /home/ /mnt/home/
rsync -raX /tmp/ /mnt/tmp/
```

- Note: the ending slash for the source is important. Without it, the parent folder is copied over too
  - Not desired
    ```
    root@ip-172-31-93-39:~# rsync -raX /home /mnt/home
    root@ip-172-31-93-39:~# ls -la /mnt/home
    total 28
    drwxr-xr-x 4 root root  4096 May 20 00:08 .
    drwxr-xr-x 5 root root  4096 May 19 23:58 ..
    drwxr-xr-x 4 root root  4096 May 20 00:03 home
    drwx------ 2 root root 16384 May 19 23:52 lost+found
    root@ip-172-31-93-39:~# ls -la /mnt/home/home
    total 16
    drwxr-xr-x 4 root  root  4096 May 20 00:03 .
    drwxr-xr-x 4 root  root  4096 May 20 00:08 ..
    drwxr-xr-x 3 admin admin 4096 May 19 22:38 admin
    drwxr-xr-x 2 root  root  4096 May 20 00:04 fun
    ```
  - desired
    ```
    rm -r /mnt/home/* -f
    root@ip-172-31-93-39:~# rsync -raX /home/ /mnt/home/
    root@ip-172-31-93-39:~# ls -la /mnt/home
    total 16
    drwxr-xr-x 4 root  root  4096 May 20 00:03 .
    drwxr-xr-x 5 root  root  4096 May 19 23:58 ..
    drwxr-xr-x 3 admin admin 4096 May 19 22:38 admin
    drwxr-xr-x 2 root  root  4096 May 20 00:04 fun
    ```

/dev/mapper/VolGroup00-var    /var    ext4  defaults  0 0
/dev/mapper/vg01-lvm_var /var  ext4  defaults  0 0



Nevermind, just mounting them as their own unique folders
--------------------------------------
Reactivate the logical volumes after attaching the EBS volume to a new instance
```
lvchange -a y /dev/vg01/lvm_var
lvchange -a y /dev/vg01/lvm_var_log
lvchange -a y /dev/vg01/lvm_tmp
lvchange -a y /dev/vg01/lvm_home
```

```
root@ip-172-31-94-19:~# lvscan
  inactive          '/dev/vg01/lvm_var' [2.00 GiB] inherit
  inactive          '/dev/vg01/lvm_var_log' [2.00 GiB] inherit
  inactive          '/dev/vg01/lvm_home' [3.00 GiB] inherit
  inactive          '/dev/vg01/lvm_tmp' [16.00 MiB] inherit
root@ip-172-31-94-19:~# lvchange -a y /dev/vg01/lvm_var
root@ip-172-31-94-19:~# lvscan
  ACTIVE            '/dev/vg01/lvm_var' [2.00 GiB] inherit
  inactive          '/dev/vg01/lvm_var_log' [2.00 GiB] inherit
  inactive          '/dev/vg01/lvm_home' [3.00 GiB] inherit
  inactive          '/dev/vg01/lvm_tmp' [16.00 MiB] inherit
```

```
mkdir /mnt/home
mount /dev/vg01/lvm_home /mnt/home
mkdir /mnt/var
mount /dev/vg01/lvm_var /mnt/var
mkdir /mnt/var/log
mount /dev/vg01/lvm_var_log /mnt/var/log
mkdir /mnt/tmp
mount /dev/vg01/lvm_tmp /mnt/tmp
```
Making it mount at boot
```
# list the ids
root@ip-172-31-94-19:~# blkid
/dev/xvda1: UUID="bcfa0792-edbe-49d5-af46-97cb341c0f23" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="7f1c3871-de96-4420-874b-81c6e44307c9"
/dev/xvda15: SEC_TYPE="msdos" UUID="1F99-9054" BLOCK_SIZE="512" TYPE="vfat" PARTUUID="34aebed0-4591-4e1b-a057-46b0328f74c5"
/dev/xvdb4: UUID="oPvSpb-sPay-rWQe-TUKz-X51q-YKa4-qywlML" TYPE="LVM2_member" PARTUUID="67e8e24d-1da7-8d47-9b52-f3b4b1627f82"
/dev/xvdb3: UUID="KBk5dw-hLu9-sQLw-iQxO-UoZA-r0vB-NgFh2m" TYPE="LVM2_member" PARTUUID="53001f53-46c4-b84c-ad51-44680974fe80"
/dev/mapper/vg01-lvm_var_log: UUID="79b01f71-d6ac-484f-af7f-fc71aff1c656" BLOCK_SIZE="4096" TYPE="ext4"
/dev/xvda14: PARTUUID="8957cadf-2ab3-614f-af0a-72febe3c1a3f"
/dev/mapper/vg01-lvm_tmp: UUID="1d0cd1b2-5fb8-433f-8885-6f4a9d7e122f" BLOCK_SIZE="1024" TYPE="ext4"
/dev/mapper/vg01-lvm_var: UUID="d10e4ee6-2d7c-4642-8867-b891320eb26e" BLOCK_SIZE="4096" TYPE="ext4"
/dev/xvdb2: PARTUUID="c1b04692-e079-9f40-b7d4-872ac9cd51e7"
/dev/xvdb1: PARTUUID="bf56cb1f-6781-bf42-a72e-f55cafccab87"
/dev/mapper/vg01-lvm_home: UUID="9cc197c3-1afc-44c4-bc75-ab5e66cd7880" BLOCK_SIZE="4096" TYPE="ext4"


# edit /etc/fstab
# /dev/mapper/vg01-lvm_tmp
UUID=1d0cd1b2-5fb8-433f-8885-6f4a9d7e122f /mnt/tmp ext4   defaults,auto 0   2
# /dev/mapper/vg01-lvm_var
UUID=d10e4ee6-2d7c-4642-8867-b891320eb26e /mnt/var ext4   defaults,auto 0   2
# /dev/mapper/vg01-lvm_home
UUID=9cc197c3-1afc-44c4-bc75-ab5e66cd7880 /mnt/home ext4  defaults,auto 0   2
# /dev/mapper/vg01-lvm_var_log
UUID=79b01f71-d6ac-484f-af7f-fc71aff1c656 /mnt/var/log ext4  defaults,auto 0   2
```
After a reboot
```
root@ip-172-31-94-19:~# df -h
Filesystem                    Size  Used Avail Use% Mounted on
udev                          473M     0  473M   0% /dev
tmpfs                          98M  560K   97M   1% /run
/dev/xvda1                    7.7G  1.1G  6.3G  15% /
tmpfs                         486M     0  486M   0% /dev/shm
tmpfs                         5.0M     0  5.0M   0% /run/lock
/dev/mapper/vg01-lvm_tmp       14M   24K   13M   1% /mnt/tmp
/dev/mapper/vg01-lvm_var      2.0G  232M  1.6G  13% /mnt/var
/dev/mapper/vg01-lvm_home     2.9G   48K  2.8G   1% /mnt/home
/dev/mapper/vg01-lvm_var_log  2.0G   34M  1.8G   2% /mnt/var/log
/dev/xvda15                   124M   12M  113M  10% /boot/efi
tmpfs                          98M     0   98M   0% /run/user/1000
```

Resizing the volume
--------------------------
- Increased size of volume from 8 to 9 GB

```
root@ip-172-31-94-19:~# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
xvda                 202:0    0    8G  0 disk
├─xvda1              202:1    0  7.9G  0 part /
├─xvda14             202:14   0    3M  0 part
└─xvda15             202:15   0  124M  0 part /boot/efi
xvdb                 202:16   0    9G  0 disk
├─xvdb1              202:17   0  500M  0 part
├─xvdb2              202:18   0  500M  0 part
├─xvdb3              202:19   0    3G  0 part
│ ├─vg01-lvm_var     254:0    0    2G  0 lvm  /mnt/var
│ ├─vg01-lvm_home    254:2    0    3G  0 lvm  /mnt/home
│ └─vg01-lvm_tmp     254:3    0   16M  0 lvm  /mnt/tmp
└─xvdb4              202:20   0    4G  0 part
  ├─vg01-lvm_var_log 254:1    0    2G  0 lvm  /mnt/var/log
  └─vg01-lvm_home    254:2    0    3G  0 lvm  /mnt/home
root@ip-172-31-94-19:~# fdisk -l
Disk /dev/xvda: 8 GiB, 8589934592 bytes, 16777216 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 3E30AB38-DA4A-9343-A909-646A2B454ADB

Device       Start      End  Sectors  Size Type
/dev/xvda1  262144 16775167 16513024  7.9G Linux root (x86-64)
/dev/xvda14   2048     8191     6144    3M BIOS boot
/dev/xvda15   8192   262143   253952  124M EFI System

Partition table entries are not in disk order.
GPT PMBR size mismatch (16777215 != 18874367) will be corrected by write.
The backup GPT table is not on the end of the device.


Disk /dev/xvdb: 9 GiB, 9663676416 bytes, 18874368 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: F31C352D-7E8A-0745-9CC0-C9613E28DCCB

Device       Start      End Sectors  Size Type
/dev/xvdb1    2048  1026047 1024000  500M Linux filesystem
/dev/xvdb2 1026048  2050047 1024000  500M Linux filesystem
/dev/xvdb3 2050048  8341503 6291456    3G Linux LVM
/dev/xvdb4 8341504 16775167 8433664    4G Linux LVM


Disk /dev/mapper/vg01-lvm_var: 2 GiB, 2147483648 bytes, 4194304 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/vg01-lvm_var_log: 2 GiB, 2147483648 bytes, 4194304 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/vg01-lvm_home: 3 GiB, 3221225472 bytes, 6291456 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/vg01-lvm_tmp: 16 MiB, 16777216 bytes, 32768 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
root@ip-172-31-94-19:~#
```

Trying just pvresize:
```
root@ip-172-31-94-19:~# pvscan
  PV /dev/xvdb3   VG vg01            lvm2 [<3.00 GiB / 0    free]
  PV /dev/xvdb4   VG vg01            lvm2 [<4.02 GiB / 0    free]
  Total: 2 [<7.02 GiB] / in use: 2 [<7.02 GiB] / in no VG: 0 [0   ]
root@ip-172-31-94-19:~# pvresize /dev/xvdb4
  Physical volume "/dev/xvdb4" changed
  1 physical volume(s) resized or updated / 0 physical volume(s) not resized
root@ip-172-31-94-19:~# pvscan
  PV /dev/xvdb3   VG vg01            lvm2 [<3.00 GiB / 0    free]
  PV /dev/xvdb4   VG vg01            lvm2 [<4.02 GiB / 0    free]
  Total: 2 [<7.02 GiB] / in use: 2 [<7.02 GiB] / in no VG: 0 [0   ]
```

Trying deleting and then recreating the partition
```
root@ip-172-31-94-19:~# fdisk /dev/xvdb

Welcome to fdisk (util-linux 2.38.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

This disk is currently in use - repartitioning is probably a bad idea.
It's recommended to umount all file systems, and swapoff all swap
partitions on this disk.


Command (m for help): d
Partition number (1-4, default 4): 4

Partition 4 has been deleted.

Command (m for help): n
Partition number (4-128, default 4): 4
First sector (8341504-18874334, default 8341504):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (8341504-18874334, default 18872319):

Created a new partition 4 of type 'Linux filesystem' and of size 5 GiB.
Partition #4 contains a LVM2_member signature.

Do you want to remove the signature? [Y]es/[N]o: n # went back and changed this to LVM later

Command (m for help): w

The partition table has been altered.
Syncing disks.

root@ip-172-31-94-19:~# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
xvda                 202:0    0    8G  0 disk
├─xvda1              202:1    0  7.9G  0 part /
├─xvda14             202:14   0    3M  0 part
└─xvda15             202:15   0  124M  0 part /boot/efi
xvdb                 202:16   0    9G  0 disk
├─xvdb1              202:17   0  500M  0 part
├─xvdb2              202:18   0  500M  0 part
├─xvdb3              202:19   0    3G  0 part
│ ├─vg01-lvm_var     254:0    0    2G  0 lvm  /mnt/var
│ ├─vg01-lvm_home    254:2    0    3G  0 lvm  /mnt/home
│ └─vg01-lvm_tmp     254:3    0   16M  0 lvm  /mnt/tmp
└─xvdb4              202:20   0    5G  0 part
  ├─vg01-lvm_var_log 254:1    0    2G  0 lvm  /mnt/var/log
  └─vg01-lvm_home    254:2    0    3G  0 lvm  /mnt/home
root@ip-172-31-94-19:~# fdisk -l
Disk /dev/xvda: 8 GiB, 8589934592 bytes, 16777216 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 3E30AB38-DA4A-9343-A909-646A2B454ADB

Device       Start      End  Sectors  Size Type
/dev/xvda1  262144 16775167 16513024  7.9G Linux root (x86-64)
/dev/xvda14   2048     8191     6144    3M BIOS boot
/dev/xvda15   8192   262143   253952  124M EFI System

Partition table entries are not in disk order.


Disk /dev/xvdb: 9 GiB, 9663676416 bytes, 18874368 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: F31C352D-7E8A-0745-9CC0-C9613E28DCCB

Device       Start      End  Sectors  Size Type
/dev/xvdb1    2048  1026047  1024000  500M Linux filesystem
/dev/xvdb2 1026048  2050047  1024000  500M Linux filesystem
/dev/xvdb3 2050048  8341503  6291456    3G Linux LVM
/dev/xvdb4 8341504 18872319 10530816    5G Linux filesystem


Disk /dev/mapper/vg01-lvm_var: 2 GiB, 2147483648 bytes, 4194304 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/vg01-lvm_var_log: 2 GiB, 2147483648 bytes, 4194304 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/vg01-lvm_home: 3 GiB, 3221225472 bytes, 6291456 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/vg01-lvm_tmp: 16 MiB, 16777216 bytes, 32768 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

Resizing lvm
--------------------
Resizing the physical volume
```
root@ip-172-31-94-19:~# pvscan
  PV /dev/xvdb3   VG vg01            lvm2 [<3.00 GiB / 0    free]
  PV /dev/xvdb4   VG vg01            lvm2 [<4.02 GiB / 0    free]
  Total: 2 [<7.02 GiB] / in use: 2 [<7.02 GiB] / in no VG: 0 [0   ]
root@ip-172-31-94-19:~# vgscan
  Found volume group "vg01" using metadata type lvm2
root@ip-172-31-94-19:~# vgdisplay
  --- Volume group ---
  VG Name               vg01
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  6
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                4
  Open LV               4
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               <7.02 GiB
  PE Size               4.00 MiB
  Total PE              1796
  Alloc PE / Size       1796 / <7.02 GiB
  Free  PE / Size       0 / 0
  VG UUID               wgPJmG-SvCM-rUew-ss9T-y6TQ-yOK5-Dn3Az3

root@ip-172-31-94-19:~# pvresize /dev/xvdb4
  Physical volume "/dev/xvdb4" changed
  1 physical volume(s) resized or updated / 0 physical volume(s) not resized
root@ip-172-31-94-19:~# pvscan
  PV /dev/xvdb3   VG vg01            lvm2 [<3.00 GiB / 0    free]
  PV /dev/xvdb4   VG vg01            lvm2 [<5.02 GiB / 1.00 GiB free]
  Total: 2 [<8.02 GiB] / in use: 2 [<8.02 GiB] / in no VG: 0 [0   ]
root@ip-172-31-94-19:~#
```
Resizing the logical volume (increasing /mnt/var/log)
- `lvextend -r -L +1G /dev/vg01/lvm_var_log /dev/xvdb4`
```
root@ip-172-31-94-19:~# df -h
Filesystem                    Size  Used Avail Use% Mounted on
udev                          473M     0  473M   0% /dev
tmpfs                          98M  552K   97M   1% /run
/dev/xvda1                    7.7G  1.1G  6.3G  15% /
tmpfs                         486M     0  486M   0% /dev/shm
tmpfs                         5.0M     0  5.0M   0% /run/lock
/dev/mapper/vg01-lvm_tmp       14M   30K   13M   1% /mnt/tmp
/dev/mapper/vg01-lvm_home     2.9G   48K  2.8G   1% /mnt/home
/dev/mapper/vg01-lvm_var      2.0G  232M  1.6G  13% /mnt/var
/dev/mapper/vg01-lvm_var_log  2.0G   50M  1.8G   3% /mnt/var/log
/dev/xvda15                   124M   12M  113M  10% /boot/efi
tmpfs                          98M     0   98M   0% /run/user/1000
root@ip-172-31-94-19:~# lvscan
  ACTIVE            '/dev/vg01/lvm_var' [2.00 GiB] inherit
  ACTIVE            '/dev/vg01/lvm_var_log' [2.00 GiB] inherit
  ACTIVE            '/dev/vg01/lvm_home' [3.00 GiB] inherit
  ACTIVE            '/dev/vg01/lvm_tmp' [16.00 MiB] inherit
root@ip-172-31-94-19:~# lvextend -r -L +1G /dev/vg01/lvm_var_log /dev/xvdb4
  Size of logical volume vg01/lvm_var_log changed from 2.00 GiB (512 extents) to 3.00 GiB (768 extents).
  Logical volume vg01/lvm_var_log successfully resized.
resize2fs 1.47.0 (5-Feb-2023)
Filesystem at /dev/mapper/vg01-lvm_var_log is mounted on /mnt/var/log; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 1
The filesystem on /dev/mapper/vg01-lvm_var_log is now 786432 (4k) blocks long.

root@ip-172-31-94-19:~# lvscan
  ACTIVE            '/dev/vg01/lvm_var' [2.00 GiB] inherit
  ACTIVE            '/dev/vg01/lvm_var_log' [3.00 GiB] inherit
  ACTIVE            '/dev/vg01/lvm_home' [3.00 GiB] inherit
  ACTIVE            '/dev/vg01/lvm_tmp' [16.00 MiB] inherit
root@ip-172-31-94-19:~# df -h
Filesystem                    Size  Used Avail Use% Mounted on
udev                          473M     0  473M   0% /dev
tmpfs                          98M  552K   97M   1% /run
/dev/xvda1                    7.7G  1.1G  6.3G  15% /
tmpfs                         486M     0  486M   0% /dev/shm
tmpfs                         5.0M     0  5.0M   0% /run/lock
/dev/mapper/vg01-lvm_tmp       14M   30K   13M   1% /mnt/tmp
/dev/mapper/vg01-lvm_home     2.9G   48K  2.8G   1% /mnt/home
/dev/mapper/vg01-lvm_var      2.0G  232M  1.6G  13% /mnt/var
/dev/mapper/vg01-lvm_var_log  2.9G   50M  2.7G   2% /mnt/var/log
/dev/xvda15                   124M   12M  113M  10% /boot/efi
tmpfs                          98M     0   98M   0% /run/user/1000
root@ip-172-31-94-19:~#
```