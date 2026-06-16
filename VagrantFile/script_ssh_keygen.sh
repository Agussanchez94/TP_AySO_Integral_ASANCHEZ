#!/bin/bash

VM1="192.168.56.10"
VM2="192.168.56.11"
USUARIO="vagrant"

if [ ! -f /home/$USUARIO/.ssh/id_rsa ]; then
    echo "Generando clave SSH..."
    sudo -u $USUARIO ssh-keygen -t rsa -b 2048 -f /home/$USUARIO/.ssh/id_rsa -N ""
else
    echo "Clave SSH ya existe, saltando..."
fi

if ! command -v sshpass &> /dev/null; then
    echo "Instalando sshpass..."
    if command -v apt-get &> /dev/null; then
        apt-get install -y sshpass > /dev/null
    elif command -v dnf &> /dev/null; then
        dnf install -y sshpass > /dev/null
    fi
fi

MI_IP=$(hostname -I | awk '{print $2}')

if [ "$MI_IP" = "$VM1" ]; then
    DESTINO=$VM2
else
    DESTINO=$VM1
fi

if ! sudo -u $USUARIO ssh -o StrictHostKeyChecking=no -o PasswordAuthentication=no $USUARIO@$DESTINO exit 2>/dev/null; then
    echo "Copiando clave SSH a $DESTINO..."
    sudo -u $USUARIO sshpass -p "vagrant" ssh-copy-id -o StrictHostKeyChecking=no $USUARIO@$DESTINO
else
    echo "SSH sin password ya funciona hacia $DESTINO, saltando..."
fi

echo ""
echo "=== Cruce de claves SSH completado ==="
