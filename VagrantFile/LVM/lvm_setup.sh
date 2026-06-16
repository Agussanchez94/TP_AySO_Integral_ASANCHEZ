#!/bin/bash

DISCO_5G="/dev/sdb"
DISCO_3G="/dev/sdc"
DISCO_2G="/dev/sdd"

if ! command -v pvcreate &> /dev/null; then
    echo "Instalando lvm2..."
    if command -v apt-get &> /dev/null; then
        apt-get install -y lvm2 > /dev/null
    elif command -v dnf &> /dev/null; then
        dnf install -y lvm2 > /dev/null
    fi
fi

for disco in $DISCO_5G $DISCO_3G $DISCO_2G; do
    if ! pvs $disco &> /dev/null; then
        echo "Creando PV en $disco..."
        pvcreate -ff -y $disco
    else
        echo "PV ya existe en $disco, saltando..."
    fi
done

if ! vgs vg_datos &> /dev/null; then
    echo "Creando VG vg_datos..."
    vgcreate vg_datos $DISCO_5G
else
    echo "VG vg_datos ya existe, saltando..."
fi

if ! vgs vg_temp &> /dev/null; then
    echo "Creando VG vg_temp..."
    vgcreate vg_temp $DISCO_3G
else
    echo "VG vg_temp ya existe, saltando..."
fi

if ! lvs vg_datos/lv_docker &> /dev/null; then
    echo "Creando LV lv_docker..."
    lvcreate -L 10M -n lv_docker vg_datos
else
    echo "LV lv_docker ya existe, saltando..."
fi

if ! lvs vg_datos/lv_workareas &> /dev/null; then
    echo "Creando LV lv_workareas..."
    lvcreate -L 2.5G -n lv_workareas vg_datos
else
    echo "LV lv_workareas ya existe, saltando..."
fi

if ! lvs vg_temp/lv_swap &> /dev/null; then
    echo "Creando LV lv_swap..."
    lvcreate -L 2.5G -n lv_swap vg_temp
else
    echo "LV lv_swap ya existe, saltando..."
fi

if ! blkid /dev/vg_datos/lv_docker &> /dev/null; then
    echo "Formateando lv_docker como ext4..."
    mkfs.ext4 /dev/vg_datos/lv_docker
fi

if ! blkid /dev/vg_datos/lv_workareas &> /dev/null; then
    echo "Formateando lv_workareas como ext4..."
    mkfs.ext4 /dev/vg_datos/lv_workareas
fi

if ! blkid /dev/vg_temp/lv_swap &> /dev/null; then
    echo "Formateando lv_swap como swap..."
    mkswap /dev/vg_temp/lv_swap
fi

mkdir -p /var/lib/docker
mkdir -p /work

if ! grep -q "lv_docker" /etc/fstab; then
    echo "Agregando lv_docker a fstab..."
    echo "/dev/vg_datos/lv_docker  /var/lib/docker  ext4  defaults  0  2" >> /etc/fstab
fi

if ! grep -q "lv_workareas" /etc/fstab; then
    echo "Agregando lv_workareas a fstab..."
    echo "/dev/vg_datos/lv_workareas  /work  ext4  defaults  0  2" >> /etc/fstab
fi

if ! grep -q "lv_swap" /etc/fstab; then
    echo "Agregando lv_swap a fstab..."
    echo "/dev/vg_temp/lv_swap  none  swap  sw  0  0" >> /etc/fstab
fi

mount -a
swapon -a

echo ""
echo "=== LVM configurado correctamente ==="
lsblk
echo ""
echo "=== Swap activa ==="
swapon --show
