#!/bin/bash

#resize disk from 20GB to 50GB
growpart /dev/nvme0n1 4

lvextend -L +20G /dev/mapper/RootVG-homeVol
lvextend -L +20G /dev/mapper/RootVG-varVol
lvextend -l +100%FREE /dev/mapper/RootVG-varTmpVol

xfs_growfs /home
xfs_growfs /var/tmp
xfs_growfs /var

dnf install fontconfig java-21-openjdk -y

# Terraform Installation
dnf install -y dnf-plugins-core
dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
dnf install terraform -y

# NodeJs installation
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y
dnf install zip unzip -y

## install docker
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl daemon-reload
systemctl enable --now docker
sleep 10
systemctl start docker
usermod -aG docker ec2-user


# install kubectl
curl -LO "https://s3.us-west-2.amazonaws.com/amazon-eks/1.35.3/2026-04-08/bin/linux/amd64/kubectl"
chmod +x kubectl
cp kubectl /usr/local/bin/

# Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin v0.68.2

## Helm
sudo dnf install -y dnf-plugins-core
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
sudo dnf install helm