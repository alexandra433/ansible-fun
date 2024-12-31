***Trying to set it up on a t2.micro***
Launched a redhat t2.micro instance with 30 gib storage
- allowed ssh, http, https traffic from anywhere

```
# Disable firewalld (skipped this one bc it does not exist)
sudo systemctl disable firewalld --now

# Disable nm-cloud-setup if exists and enabled
sudo systemctl disable nm-cloud-setup.service nm-cloud-setup.timer
sudo reboot

sudo dnf install -y git curl
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.29.6+k3s2 sh -s - --write-kubeconfig-mode 644
cd ~
git clone https://github.com/kurokobo/awx-on-k3s.git
cd awx-on-k3s
git checkout 2.19.1
kubectl apply -k operator
```