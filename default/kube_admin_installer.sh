echo "[swap off ]"
sudo swapoff -a && sudo sed -i '/swap/s/^/#/' /etc/fstab

echo "[IPTABLE off ]"

sudo cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
 
sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

sudo systemctl stop firewalld
sudo systemctl disable firewalld


echo "[Install k8s base package]"
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

echo "[signing k8s package]"
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
sudo echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list


echo "[Install k8s package]"
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "[enable k8s package]"
sudo systemctl daemon-reload
sudo systemctl restart kubelet

echo "[container setting for k8s]"
sudo mkdir /etc/docker
 
 
sudo cat <<EOF | sudo tee /etc/docker/daemon.json
{
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {
"max-size": "100m"
},
"storage-driver": "overlay2"
}
EOF
  
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker
 
 
sudo kubeadm reset

echo "[Install k8s admin start]"

sudo kubeadm init

echo "[Install k8s network install]"

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
