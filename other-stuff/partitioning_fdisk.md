Launched a t2.micro instance with Debian 12 ami. 8 gib storage

Going to create 3 partitions (https://www.reddit.com/r/debian/comments/16lckno/lvm_help/):
 1) BIOS boot Partition
 2) EFI System partition
 3) 3rd partition
    - LVM physical volume
    - logical vol: vg0/swap
    - Logical vol: vg0/root
    - Logical vol: vg0/home
    - logical vol: vg0/tmp


- https://medium.com/@ahmedmansouri/a-guide-to-partitioning-the-ebs-root-volume-on-your-linux-ec2-instance-6db838218e36
- Stop the instance (source instance)
- Detach the root volume of the source instance (source_vol)
  - In AWS console, in EC2 instance window, go to Storage tab, click into the volume listed under Block Devices. Select Actions > Detach volume
- Create another instance used as a rescue instance in order to manipulate the volumes and the partitions (same AZ, same AMI)
- Create a new EBS volume (target_vol) in same AZ with size at least equal to source_vol (10 gib this time)
- Attach both target_vol and source_vol to the rescue instance. Named them /dev/sdb and /dev/sdc respectively
- Connect to rescue instance

```
root@ip-172-31-20-98:~# fdisk -l
Disk /dev/xvda: 8 GiB, 8589934592 bytes, 16777216 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 4C8ABF3E-4922-7344-A83C-956F5C464B08

Device       Start      End  Sectors  Size Type
/dev/xvda1  262144 16775167 16513024  7.9G Linux root (x86-64)
/dev/xvda14   2048     8191     6144    3M BIOS boot
/dev/xvda15   8192   262143   253952  124M EFI System

Partition table entries are not in disk order.


Disk /dev/xvdc: 8 GiB, 8589934592 bytes, 16777216 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 4C8ABF3E-4922-7344-A83C-956F5C464B08

Device       Start      End  Sectors  Size Type
/dev/xvdc1  262144 16775167 16513024  7.9G Linux root (x86-64)
/dev/xvdc14   2048     8191     6144    3M BIOS boot
/dev/xvdc15   8192   262143   253952  124M EFI System

Partition table entries are not in disk order.


Disk /dev/xvdb: 10 GiB, 10737418240 bytes, 20971520 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```
```
root@ip-172-31-20-98:~# lsblk
NAME     MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
xvda     202:0    0    8G  0 disk
├─xvda1  202:1    0  7.9G  0 part /
├─xvda14 202:14   0    3M  0 part
└─xvda15 202:15   0  124M  0 part /boot/efi
xvdb     202:16   0   10G  0 disk
xvdc     202:32   0    8G  0 disk
├─xvdc1  202:33   0  7.9G  0 part
├─xvdc14 202:46   0    3M  0 part
└─xvdc15 202:47   0  124M  0 part
```
 - xvda is the rescue instance root volume
 - xvdb is the target_vol
 - xvdc is the source_vol

Partioning with fdisk:
https://www.digitalocean.com/community/tutorials/create-a-partition-in-linux
- Choose the /dev/xvdb disk to partition
```
fdisk /dev/xvdb

root@ip-172-31-20-98:~# fdisk /dev/xvdb

Welcome to fdisk (util-linux 2.38.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS (MBR) disklabel with disk identifier 0x82c45ca8.

Command (m for help):
```

First, use the "g" command to cread a new GPT disklabel
```
root@ip-172-31-20-98:/# fdisk /dev/xvdb

Welcome to fdisk (util-linux 2.38.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS (MBR) disklabel with disk identifier 0xae2b1cd3.

Command (m for help): g
Created a new GPT disklabel (GUID: 9BE445F1-45BE-AF44-B579-E0C02D24CEFE).
```

Create a new partition using the commnand "n":
- (if not using gpt) You will be prompted to specify the type of parition you want
  - l: logical partition
   - unlimited number
  - p: primary partition
    - only 4 primary partitions on a single disk (3 if you decided to have an extended partition) (because fdisk is not GPT aware?)

Create BIOS boot Partition and efi filesystem partition
```
Command (m for help): n
Partition number (1-128, default 1): 1
First sector (2048-20971486, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-20971486, default 20969471): +4M

Created a new partition 1 of type 'Linux filesystem' and of size 4 MiB.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2): 2
First sector (10240-20971519, default 10240):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (10240-20971519, default 20971519): +130M

Created a new partition 2 of type 'Linux' and of size 130 MiB.
```

Created a partition of the rest of the disk
```
Command (m for help): n
Partition type
   p   primary (2 primary, 0 extended, 2 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (3,4, default 3): 3
First sector (276480-20971519, default 276480):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (276480-20971519, default 20971519):

Created a new partition 3 of type 'Linux' and of size 9.9 GiB.

Command (m for help):
```

Make it a linux LVM:
```
Command (m for help): n
Partition type
   p   primary (2 primary, 0 extended, 2 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (3,4, default 3): 3
First sector (276480-20971519, default 276480):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (276480-20971519, default 20971519):

Created a new partition 3 of type 'Linux' and of size 9.9 GiB.

Command (m for help): t
Partition number (1-3, default 3): 3
Hex code or alias (type L to list all): L

# Removed the list (L) output

Hex code or alias (type L to list all): 8e

Changed type of partition 'Linux' to 'Linux LVM'.

Command (m for help): p
Disk /dev/xvdb: 10 GiB, 10737418240 bytes, 20971520 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x82c45ca8

Device     Boot  Start      End  Sectors  Size Id Type
/dev/xvdb1        2048    10239     8192    4M 83 Linux
/dev/xvdb2       10240   276479   266240  130M 83 Linux
/dev/xvdb3      276480 20971519 20695040  9.9G 8e Linux LVM
```

Write changes with "w"
```
Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

**LVM setup**
---------------------
Install lvm2
- `apt update && apt install lvm2`

Create a physical volume from /dev/xvdb3:
```
pvcreate /dev/xvdb3

root@ip-172-31-20-98:~# pvcreate /dev/xvdb3
  Physical volume "/dev/xvdb3" successfully created.
```

Create an LVM volume group called vg0
```
vgcreate vg0 /dev/xvdb3

root@ip-172-31-20-98:~# vgcreate vg0 /dev/xvdb3
  Volume group "vg0" successfully created
root@ip-172-31-20-98:~# vgdisplay
  --- Volume group ---
  VG Name               vg0
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <9.87 GiB
  PE Size               4.00 MiB
  Total PE              2526
  Alloc PE / Size       0 / 0
  Free  PE / Size       2526 / <9.87 GiB
  VG UUID               8NGxf5-azM1-0B6e-JGxv-nXWU-h8nw-puzSoF
```

Create logical volumes for vg0/swap, vg0/root, vg0/home, vg0/tmp, vg0/var
 - There's like 9 gib total
 - Not entirely sure how to allocate space tbh
```
lvcreate -L 500M -n vg0_swap vg0
lvcreate -L 2G -n vg0_root vg0
lvcreate -L 3G -n vg0_home vg0
lvcreate -L 2G -n vg0_var vg0
lvcreate -L 2G -n vg0_tmp vg0

root@ip-172-31-20-98:~# lsblk
NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
xvda             202:0    0    8G  0 disk
├─xvda1          202:1    0  7.9G  0 part
├─xvda14         202:14   0    3M  0 part
└─xvda15         202:15   0  124M  0 part /boot/efi
xvdb             202:16   0   10G  0 disk
├─xvdb1          202:17   0    4M  0 part
├─xvdb2          202:18   0  130M  0 part
└─xvdb3          202:19   0  9.9G  0 part
  ├─vg0-vg0_swap 254:0    0  500M  0 lvm
  ├─vg0-vg0_root 254:1    0    2G  0 lvm
  ├─vg0-vg0_home 254:2    0    3G  0 lvm
  ├─vg0-vg0_var  254:3    0    2G  0 lvm
  └─vg0-vg0_tmp  254:4    0    2G  0 lvm
xvdc             202:32   0    8G  0 disk
├─xvdc1          202:33   0  7.9G  0 part /
├─xvdc14         202:46   0    3M  0 part
└─xvdc15         202:47   0  124M  0 part
```

Make filesystems on the new LVs:
```
mkfs -t ext4 "/dev/vg0/vg0_root"
mkfs -t ext4 "/dev/vg0/vg0_home"
mkfs -t ext4 "/dev/vg0/vg0_var"
mkfs -t ext4 "/dev/vg0/vg0_tmp"
```

Mount the partitions
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
- Mount the source_vol under `/mnt/source_vol` and all other partitions under the appropriate `/mnt/target_vol` directory
  ```
  mount /dev/xvdc1 /mnt/source_vol/
  mount /dev/vg0/vg0_root /mnt/target_vol/root/
  mount /dev/vg0/vg0_home /mnt/target_vol/home/
  mount /dev/vg0/vg0_var /mnt/target_vol/var/
  mount /dev/vg0/vg0_tmp /mnt/target_vol/tmp/
  ```
  - Result:
    ```
    root@ip-172-31-20-98:~# lsblk
    NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
    xvda             202:0    0    8G  0 disk
    ├─xvda1          202:1    0  7.9G  0 part
    ├─xvda14         202:14   0    3M  0 part
    └─xvda15         202:15   0  124M  0 part /boot/efi
    xvdb             202:16   0   10G  0 disk
    ├─xvdb1          202:17   0    4M  0 part
    ├─xvdb2          202:18   0  130M  0 part
    └─xvdb3          202:19   0  9.9G  0 part
      ├─vg0-vg0_swap 254:0    0  500M  0 lvm
      ├─vg0-vg0_root 254:1    0    2G  0 lvm  /mnt/target_vol/root
      ├─vg0-vg0_home 254:2    0    3G  0 lvm  /mnt/target_vol/home
      ├─vg0-vg0_var  254:3    0    2G  0 lvm  /mnt/target_vol/var
      └─vg0-vg0_tmp  254:4    0    2G  0 lvm  /mnt/target_vol/tmp
    xvdc             202:32   0    8G  0 disk
    ├─xvdc1          202:33   0  7.9G  0 part /mnt/source_vol
    │                                         /
    ├─xvdc14         202:46   0    3M  0 part
    └─xvdc15         202:47   0  124M  0 part
    ```

Synchronize the "source_vol" volume content into the appropriate new partitions
- Start with non root partitions (`apt install rsync` first)
  ```
  rsync -av /mnt/source_vol/home/ /mnt/target_vol/home/
  rsync -av /mnt/source_vol/var/ /mnt/target_vol/var/
  rsync -av /mnt/source_vol/tmp/ /mnt/target_vol/tmp/
  ```
  - https://www.geeksforgeeks.org/rsync-command-in-linux-with-examples/
- Now, we need to exclude the partitions above when synchronising the "/" partition
  ```
  rsync -av --exclude=home --exclude=var --exclude=tmp /mnt/source_vol/ /mnt/target_vol/root/
  ```

Need to move target_vol/home/, var, and tmp into target_vol/root/
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

  mount /dev/vg0/vg0_home /mnt/target_vol/root/home/
  mount /dev/vg0/vg0_var /mnt/target_vol/root/var/
  mount /dev/vg0/vg0_tmp /mnt/target_vol/root/tmp/
  ```

***Extra***
---------------------
All commands:
```
Command (m for help): m

Help:

  DOS (MBR)
   a   toggle a bootable flag
   b   edit nested BSD disklabel
   c   toggle the dos compatibility flag

  Generic
   d   delete a partition
   F   list free unpartitioned space
   l   list known partition types
   n   add a new partition
   p   print the partition table
   t   change a partition type
   v   verify the partition table
   i   print information about a partition

  Misc
   m   print this menu
   u   change display/entry units
   x   extra functionality (experts only)

  Script
   I   load disk layout from sfdisk script file
   O   dump disk layout to sfdisk script file

  Save & Exit
   w   write table to disk and exit
   q   quit without saving changes

  Create a new label
   g   create a new empty GPT partition table
   G   create a new empty SGI (IRIX) partition table
   o   create a new empty MBR (DOS) partition table
   s   create a new empty Sun partition table
```

Hex codes and aliases
```
Hex code or alias (type L to list all): L

00 Empty            27 Hidden NTFS Win  82 Linux swap / So  c1 DRDOS/sec (FAT-
01 FAT12            39 Plan 9           83 Linux            c4 DRDOS/sec (FAT-
02 XENIX root       3c PartitionMagic   84 OS/2 hidden or   c6 DRDOS/sec (FAT-
03 XENIX usr        40 Venix 80286      85 Linux extended   c7 Syrinx
04 FAT16 <32M       41 PPC PReP Boot    86 NTFS volume set  da Non-FS data
05 Extended         42 SFS              87 NTFS volume set  db CP/M / CTOS / .
06 FAT16            4d QNX4.x           88 Linux plaintext  de Dell Utility
07 HPFS/NTFS/exFAT  4e QNX4.x 2nd part  8e Linux LVM        df BootIt
08 AIX              4f QNX4.x 3rd part  93 Amoeba           e1 DOS access
09 AIX bootable     50 OnTrack DM       94 Amoeba BBT       e3 DOS R/O
0a OS/2 Boot Manag  51 OnTrack DM6 Aux  9f BSD/OS           e4 SpeedStor
0b W95 FAT32        52 CP/M             a0 IBM Thinkpad hi  ea Linux extended
0c W95 FAT32 (LBA)  53 OnTrack DM6 Aux  a5 FreeBSD          eb BeOS fs
0e W95 FAT16 (LBA)  54 OnTrackDM6       a6 OpenBSD          ee GPT
0f W95 Ext'd (LBA)  55 EZ-Drive         a7 NeXTSTEP         ef EFI (FAT-12/16/
10 OPUS             56 Golden Bow       a8 Darwin UFS       f0 Linux/PA-RISC b
11 Hidden FAT12     5c Priam Edisk      a9 NetBSD           f1 SpeedStor
12 Compaq diagnost  61 SpeedStor        ab Darwin boot      f4 SpeedStor
14 Hidden FAT16 <3  63 GNU HURD or Sys  af HFS / HFS+       f2 DOS secondary
16 Hidden FAT16     64 Novell Netware   b7 BSDI fs          f8 EBBR protective
17 Hidden HPFS/NTF  65 Novell Netware   b8 BSDI swap        fb VMware VMFS
18 AST SmartSleep   70 DiskSecure Mult  bb Boot Wizard hid  fc VMware VMKCORE
1b Hidden W95 FAT3  75 PC/IX            bc Acronis FAT32 L  fd Linux raid auto
1c Hidden W95 FAT3  80 Old Minix        be Solaris boot     fe LANstep
1e Hidden W95 FAT1  81 Minix / old Lin  bf Solaris          ff BBT
24 NEC DOS

Aliases:
   linux          - 83
   swap           - 82
   extended       - 05
   uefi           - EF
   raid           - FD
   lvm            - 8E
   linuxex        - 85
```

https://phoenixnap.com/kb/linux-create-partition
https://howto.biapy.com/en/debian-gnu-linux/system/setup/setup-and-use-the-logical-volume-manager-lvm-on-debian