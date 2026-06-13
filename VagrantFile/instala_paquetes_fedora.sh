#!/bin/bash

echo "Actualizando repositorios..."
sudo dnf update -y > /dev/null

echo "Instalando paquetes base incluyendo lvm2 y sshpass..."
sudo dnf install -y tree ansible ca-certificates curl htop tmux lvm2 sshpass

echo "Instalando speedtest-cli..."
sudo dnf install -y speedtest-cli || pip3 install speedtest-cli

echo "Removiendo versiones viejas de docker..."
sudo dnf remove -y docker docker-client docker-client-latest docker-common \
  docker-latest docker-latest-logrotate docker-logrotate docker-selinux \
  docker-engine-selinux docker-engine

echo "Agregando repositorio de Docker..."
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

echo "Instalando Docker..."
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Agregando vagrant al grupo docker..."
sudo usermod -a -G docker vagrant

echo "Habilitando y arrancando Docker..."
sudo systemctl enable --now docker
