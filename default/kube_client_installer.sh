echo "[INSTALL BASE PACKAGE]"
sudo apt-get update
 
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "[INSTALL docker archive]"
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "[INSTALL signing keyring]"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


echo "[INSTALL docker engine]"
sudo apt-get update -y 
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

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
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "[enable k8s package]"
sudo systemctl daemon-reload
sudo systemctl restart kubelet


#sudo kubeadm join 10.0.100.40:6443 --token zbgv72.v9ac8xhex128xjwp \
#        --discovery-token-ca-cert-hash sha256:2193f25bad65918197d7b543e282327741bdd99748b1a6d879e1b4dc
