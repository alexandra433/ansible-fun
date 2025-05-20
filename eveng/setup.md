https://www.eve-ng.net/index.php/documentation/community-cookbook/
https://www.eve-ng.net/index.php/documentation/professional-cookbook/

page 34 of professional cookbook

GCP version
---------------------
1. Go to cloud shell, create a nested Ubuntu 22.04 image

```
gcloud compute images create nested-ubuntu-jammy --source-image-family=ubuntu-2204-lts --source-image-project=ubuntu-os-cloud --licenses https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx
```

2. Create the VM

Menu > Compute instances > VM instance > create instance
  - General purpose, N2
  - n2-standard-8 (8 vCPU, 4 core, 32 GB memory)

OS and storage > Change > Custom images tab > select the previously created images
  - Boot disk type = SSD persistent disk'
  - Size = 100 GB

Security > identity and API access > access scopes
  - Allow default access

Networking > firewall
  - allow http traffic

Create the vm

3. download eveng
  - ssh into the server
  ```
  sudo -i
  wget -O - https://www.eve-ng.net/jammy/install-eve.sh | bash -i
  apt update
  apt upgrade
  reboot
  ```
4. Setup IP

IMPORTANT: once ip wizard screen appears, press control + c and `sudo -i`

debugged237

Make sure dhcp 

reboot

5. Access web UI with http
Default web login: admin/eve
Use html5 console (so you can connect to nodes later)


Uploading an image
------------------------------
https://networkhunt.com/how-to-add-cisco-virl-vios-images-to-eve-ng/
https://www.eve-ng.net/index.php/documentation/howtos/howto-add-cisco-vios-from-virl/

https://github.com/hegdepavankumar/Cisco-Images-for-GNS3-and-EVE-NG
Downloaded the following from https://github.com/hegdepavankumar/Cisco-Images-for-GNS3-and-EVE-NG#cisco-ios-routers-images-for-eve-ng
  - c7200-adventerprisek9-mz.153-3.XB12.image
  - c7200-adventerprisek9-mz.152-4.S6.image
  - c7200-adventerprisek9-mz.124-24.T5.image
https://github.com/hegdepavankumar/Cisco-Images-for-GNS3-and-EVE-NG?tab=readme-ov-file#cisco-vios
  - vios-adventerprisek9-m.SPA.159-3.M6.tgz
  - viosl2-adventerprisek9-m.ssa.high_iron_20200929.tgz

unzipped

SSHed into server with WinSCP with root account
Go to /opt/unetlab/addons

upload the ios images to /opt/unetlab/addons/dynamips

For vios images: https://www.eve-ng.net/index.php/documentation/howtos/howto-add-cisco-vios-from-virl/

Router: `mkdir /opt/unetlab/addons/qemu/vios-adventerprisek9-m.SPA.159-3.M6`
Switch: `mkdir /opt/unetlab/addons/qemu/viosl2-adventerprisek9-m.SSA.high_iron_20200929`

upload the vios images to their respective folders in /opt/unetlab/addons/qemu
 - Downloaded files should already be named `virtioa.qcow2 `, if not then just rename them

Once all uploaded, need to run fixpermissions command
```
cd into the folders?
/opt/unetlab/wrappers/unl_wrapper -a fixpermissions
```
