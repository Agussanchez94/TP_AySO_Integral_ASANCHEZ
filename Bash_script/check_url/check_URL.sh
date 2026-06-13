#!/bin/bash

# =============================================================
# Script de Chequeo de URLs
# Responsable: R3 - Automatizacion Nivel 1
# Descripción: Verifica si las URLs de la lista están online
# Es idempotente: se puede ejecutar múltiples veces sin romper
# =============================================================

LISTA="$(dirname "$0")/Lista_URL.txt"
LOG="/var/log/check_url.log"
FECHA=$(date '+%Y-%m-%d %H:%M:%S')

# ── PASO 1: Verificar que curl está instalado ────────────────
if ! command -v curl &> /dev/null; then
    echo "Error: curl no está instalado"
    exit 1
fi

# ── PASO 2: Verificar que existe la lista ───────────────────
if [ ! -f "$LISTA" ]; then
    echo "Error: no se encontró $LISTA"
    exit 1
fi

echo "=== Chequeo de URLs - $FECHA ==="
echo ""

# Contadores
OK=0
FAIL=0

# ── PASO 3: Leer lista y chequear cada URL ───────────────────
while read -r url; do
    # Ignorar líneas vacías y comentarios
    [[ -z "$url" ]] && continue
    [[ "$url" =~ ^#.*$ ]] && continue

    # Chequear URL con curl (timeout 5 segundos)
    HTTP_CODE=$(curl -o /dev/null -s -w "%{http_code}" --max-time 5 "$url")

    if [ "$HTTP_CODE" -ge 200 ] && [ "$HTTP_CODE" -lt 400 ]; then
        echo "✅ OK    [$HTTP_CODE] $url"
        OK=$((OK+1))
    else
        echo "❌ FAIL  [$HTTP_CODE] $url"
        FAIL=$((FAIL+1))
    fi

done < "$LISTA"

echo ""
echo "=== Resumen ==="
echo "Total OK:   $OK"
echo "Total FAIL: $FAIL"
echo ""

# ── PASO 4: Guardar resultado en log ─────────────────────────
echo "[$FECHA] OK: $OK - FAIL: $FAIL" >> $LOG

