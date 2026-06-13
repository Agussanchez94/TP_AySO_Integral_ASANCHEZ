#!/bin/bash

# =============================================================
# Script de Alta de Usuarios
# Responsable: R3 - Automatizacion Nivel 1
# Descripción: Crea usuarios, grupos y asigna permisos
# Es idempotente: si el usuario ya existe no lo vuelve a crear
# =============================================================

LISTA="$(dirname "$0")/Lista_Usuarios.txt"
GRUPO_SECUNDARIO="ASANCHEZ"
CLAVE_DEFAULT="vagrant"

# ── PASO 1: Crear grupo secundario si no existe ──────────────
if ! getent group $GRUPO_SECUNDARIO > /dev/null; then
    echo "Creando grupo secundario $GRUPO_SECUNDARIO..."
    groupadd $GRUPO_SECUNDARIO
else
    echo "Grupo $GRUPO_SECUNDARIO ya existe, saltando..."
fi

# ── PASO 2: Leer lista y crear usuarios ──────────────────────
while IFS=: read -r usuario grupo comentario; do
    # Ignorar líneas que empiezan con #
    [[ "$usuario" =~ ^#.*$ ]] && continue
    # Ignorar líneas vacías
    [[ -z "$usuario" ]] && continue

    # Crear grupo principal si no existe
    if ! getent group $grupo > /dev/null; then
        echo "Creando grupo principal $grupo..."
        groupadd $grupo
    else
        echo "Grupo $grupo ya existe, saltando..."
    fi

    # Crear usuario si no existe
    if ! id "$usuario" &> /dev/null; then
        echo "Creando usuario $usuario..."
        useradd -m -g $grupo -G $GRUPO_SECUNDARIO -c "$comentario" -s /bin/bash $usuario
        echo "$usuario:$CLAVE_DEFAULT" | chpasswd
        echo "Usuario $usuario creado con clave: $CLAVE_DEFAULT"
    else
        echo "Usuario $usuario ya existe, saltando..."
    fi

done < "$LISTA"

echo ""
echo "=== Usuarios creados ==="
cat $LISTA | grep -v "^#" | grep -v "^$" | cut -d: -f1 | while read u; do
    id $u
done

