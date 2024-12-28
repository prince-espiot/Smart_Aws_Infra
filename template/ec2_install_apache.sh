#! /bin/bash
#install apache2
cd /home/ubuntu
yes | sudo apt update
yes | sudo apt install apache2
echo "<h1>Server Details</h1><p><strong>Hostname:</strong> $(hostname)</p><p><strong>IP Address:</strong> $(hostname -I | cut -d" " -f1)</p>" > /var/www/html/index.html
sudo systemctl restart apache2


#install git
sudo apt install -y git-all
# Update package list and install locales
sudo apt-get update
sudo apt-get install -y locales-all

# Install necessary packages for adding HTTPS support to APT
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

# Ensure the /etc/apt/keyrings directory exists
sudo mkdir -p -m 755 /etc/apt/keyrings

# Add the Kubernetes APT key and repository
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list

# Update package list and install kubectl
sudo apt-get update
sudo apt-get install -y kubectl

# Install Flux CLI
curl -s https://fluxcd.io/install.sh | sudo bash
. <(flux completion bash)

# Install age encryption tool
sudo apt-get install -y age

# Install PostgreSQL
sudo apt-get install -y postgresql

# Download and install SOPS
wget https://github.com/getsops/sops/releases/download/v3.8.1/sops_3.8.1_amd64.deb
sudo dpkg --install sops_3.8.1_amd64.deb
rm -f sops_3.8.1_amd64.deb

# Download and install K9s for ARM64 architecture (if needed)
wget https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_linux_arm64.deb
sudo dpkg --install k9s_linux_arm64.deb
rm -f k9s_linux_arm64.deb

# Add Docker's official GPG key
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository to Apt sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Update package list
sudo apt-get update

# Download and install K9s for AMD64 architecture
wget https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_linux_amd64.deb
sudo dpkg --install k9s_linux_amd64.deb
rm -f k9s_linux_amd64.deb

#Install Eksctl
# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

sudo mv /tmp/eksctl /usr/local/bin

#Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

#Install Kustomize  
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
sudo mv kustomize /usr/local/bin

#install unzip
sudo apt-get install -y unzip

#install argocd cli 
VERSION=$(curl -L -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION)
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v$VERSION/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

#install awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Confirm installations
kubectl version --client
flux --version
age --version
psql --version
sops --version
k9s version

echo "All installations completed successfully."
