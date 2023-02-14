echo "[INSTALL BASE PACKAGE]"
sudo apt-get update
 
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "[INSTALL docker archive]"
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "[INSTALL signing keyring]"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[INSTALL docker engine]"
sudo apt-get update -y 
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

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
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl

echo "[signing k8s package]"
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
sudo echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "[Install k8s package]"
sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni 
sudo apt-get install -y ipvsadm
sudo apt-mark hold kubelet kubeadm kubectl

echo "[enable k8s package]"
sudo systemctl daemon-reload
sudo systemctl restart kubelet
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd

iptables --policy INPUT   ACCEPT
iptables --policy OUTPUT  ACCEPT
iptables --policy FORWARD ACCEPT
iptables -Z # zero counters
iptables -F # flush (delete) rules
iptables -X # delete all extra chains
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t raw -F
iptables -t raw -X

sudo systemctl stop apparmor
sudo systemctl disable apparmor 
sudo systemctl restart containerd.service

sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.ipv4.ip_forward=1


#sudo kubeadm join 10.0.100.40:6443 --token zbgv72.v9ac8xhex128xjwp \
#        --discovery-token-ca-cert-hash sha256:2193f25bad65918197d7b543e282327741bdd99748b1a6d879e1b4dc
