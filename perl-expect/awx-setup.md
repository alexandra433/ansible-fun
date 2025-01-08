**Provision instance**
-----------------------------------
Launched a t2.medium with redhat ami. Allow ssh, https, http traffic from anywhere
30 gib storage

**Install AWX**
-----------------------------------
https://github.com/kurokobo/awx-on-k3s

```
# Disable firewalld (Did not exist)
sudo systemctl disable firewalld --now

# Disable nm-cloud-setup if exists and enabled
sudo systemctl disable nm-cloud-setup.service nm-cloud-setup.timer
sudo reboot
```
Install required packages
```
sudo dnf install -y git curl
```
Install K3s
```
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.29.6+k3s2 sh -s - --write-kubeconfig-mode 644
```
Install AWX Operator
```
cd ~
git clone https://github.com/kurokobo/awx-on-k3s.git
cd awx-on-k3s
git checkout 2.19.1

# Deploy awx operatr
kubectl apply -k operator

# Wait for containers to be ready
kubectl -n awx get all
```

Prepare required files to deploy AWX
Generate a Self-Signed certificate.
```
AWX_HOST="awx.justforme.com"
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -out ./base/tls.crt -keyout ./base/tls.key -subj "/CN=${AWX_HOST}/O=${AWX_HOST}" -addext "subjectAltName = DNS:${AWX_HOST}"

```
Modify hostname in base/awx.yaml
```
...
spec:
  ...
  ingress_type: ingress
  ingress_hosts:
    - hostname: awx.justforme.com
      tls_secret: awx-secret-tls
...
```
Modify the two password entries in base/kustomization.yaml
```
...
  - name: awx-postgres-configuration
    type: Opaque
    literals:
      - host=awx-postgres-15
      - port=5432
      - database=awx
      - username=awx
      - password=<your_password>
      - type=managed

  - name: awx-admin-password
    type: Opaque
    literals:
      - password=<your_password>
...
```
Prepare directories for Persistent Volumes defined in base/pv.yaml. These directories will be used to store your databases and project files.
```
sudo mkdir -p /data/postgres-15
sudo mkdir -p /data/projects
sudo chown 1000:0 /data/projects
```
Deploy AWX (takes a few minutes)
```
kubectl apply -k base

# check logs
kubectl -n awx logs -f deployments/awx-operator-controller-manager

# when logs finish, check that everything was deployed
kubectl -n awx get awx,all,ingress,secrets
```

 - After running kubectl apply -k base, the server got stuck on one of the jobs and kicked me out. Maybe t2.medium isn't enough