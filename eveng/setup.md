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