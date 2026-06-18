# TP_AySO_Integral - Grupo ASANCHEZ

## Materia
Arquitectura y Sistemas Operativos  
Tecnicatura Universitaria en Programación - UTN FRA

## Datos del Grupo
- **Nombre del Grupo:** ASANCHEZ
- **División:** 314
- **Turno:** Noche

## Integrantes

| Rol | Nombre | Apellido |
|-----|--------|----------|
| R1 - Líder | Agustin | Sanchez |
| R3 - Automatización N1 | Fabricio | Papetti |

## Estructura del Repositorio

.
├── Bash_script/
│   ├── alta_usuarios/
│   │   ├── alta_usuarios.sh          # Script de alta de usuarios
│   │   └── Lista_Usuarios.txt        # Lista de usuarios a crear
│   └── check_url/
│       ├── check_URL.sh              # Script de chequeo de URLs
│       └── Lista_URL.txt             # Lista de URLs a chequear
├── ansible/
│   ├── ansible.cfg                   # Configuración de Ansible
│   ├── playbook.yml                  # Playbook principal
│   ├── inventory/
│   │   └── hosts                     # Inventario de VMs
│   └── roles/
│       ├── TP_INI/                   # Crea archivo de datos del grupo
│       ├── Alta_Usuarios_ASANCHEZ/   # Crea usuarios y grupos
│       ├── Sudoers_ASANCHEZ/         # Configura sudo sin password
│       └── Instala-tools_ASANCHEZ/   # Instala htop, tmux y speedtest-cli
├── VagrantFile/
│   └── Vagrantfile                   # Configuración de las VMs
├── LVM/
│   └── lvm_setup.sh                  # Configuración de LVM
└── integrantes.txt                   # Lista de integrantes

## Infraestructura (R2)

2 VMs con QEMU (Apple Silicon):
- **VM1-Grupo-ASANCHEZ** - Ubuntu 22.04 ARM64 (Testing)
- **VM2-Grupo-ASANCHEZ** - Ubuntu 22.04 ARM64 (Producción)

### Discos y LVM

| VG | LV | Tamaño | Punto de Montaje |
|----|----|--------|-----------------|
| vg_datos | lv_docker | 10M | /var/lib/docker |
| vg_datos | lv_workareas | 2.5GB | /work |
| vg_temp | lv_swap | 1.9GB | SWAP |

## Bash Scripting (R3)

### Alta de Usuarios
Crea usuarios y grupos en el sistema a partir de una lista:
\`\`\`bash
sudo bash Bash_script/alta_usuarios/alta_usuarios.sh
\`\`\`

### Chequeo de URLs
Verifica si una lista de URLs están online:
\`\`\`bash
sudo bash Bash_script/check_url/check_URL.sh
\`\`\`

## Ansible (R4)

Ejecutar el playbook desde VM1:
\`\`\`bash
cd ansible/
ansible-playbook -i inventory/hosts playbook.yml
\`\`\`

### Roles
- **TP_INI** - Crea `/tmp/Grupo/datos.txt` con info del grupo
- **Alta_Usuarios_ASANCHEZ** - Crea usuarios y grupos en ambas VMs
- **Sudoers_ASANCHEZ** - Configura sudo sin password para el grupo
- **Instala-tools_ASANCHEZ** - Instala htop, tmux y speedtest-cli
