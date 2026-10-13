#!/usr/bin/env bash

set -o pipefail
export LC_ALL=C

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${TOOLKIT_CONFIG:-$SCRIPT_DIR/../config/toolkit.conf}"

if [[ ! -r "$CONFIG_FILE" ]]; then
    printf 'Erreur : fichier de configuration illisible ou absent : %s\n' "$CONFIG_FILE" >&2
    exit 1
fi

SERVER_NAME=""
REPORT_PATH=""

while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ ^[[:space:]]*([A-Za-z_][A-Za-z0-9_-]*)[[:space:]]*=[[:space:]]*(.*)$ ]] || continue

    key="${BASH_REMATCH[1]}"
    value="${BASH_REMATCH[2]}"
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    value="${value%$'\r'}"

    case "$key" in
        SERVER_NAME) SERVER_NAME="$value" ;;
        REPORT_PATH) REPORT_PATH="$value" ;;
    esac
done < "$CONFIG_FILE"

if [[ -z "$SERVER_NAME" ]]; then
    SERVER_NAME="$(hostname 2>/dev/null || printf 'inconnu')"
fi

if [[ -z "$REPORT_PATH" ]]; then
    printf 'Erreur : REPORT_PATH est absent ou vide dans %s\n' "$CONFIG_FILE" >&2
    exit 1
fi

if [[ -d "$REPORT_PATH" || "$REPORT_PATH" == */ ]]; then
    report_directory="$REPORT_PATH"
    report_name="system-monitor-$(date '+%Y%m%d-%H%M%S').txt"
    report_file="${report_directory%/}/$report_name"
else
    report_file="$REPORT_PATH"
    report_directory="$(dirname -- "$report_file")"
fi

if ! mkdir -p -- "$report_directory"; then
    printf 'Erreur : impossible de créer le répertoire du rapport : %s\n' "$report_directory" >&2
    exit 1
fi

server_hostname="$(hostname -f 2>/dev/null || hostname 2>/dev/null || printf 'inconnu')"
report_date="$(date '+%Y-%m-%d %H:%M:%S %Z')"

{
    printf '%s\n' '============================================================'
    printf '%s\n' '                 RAPPORT DE SURVEILLANCE SYSTEME'
    printf '%s\n' '============================================================'
    printf 'Serveur             : %s\n' "$SERVER_NAME"
    printf "Nom d'hote Linux    : %s\n" "$server_hostname"
    printf 'Date et heure       : %s\n' "$report_date"

    printf '\n%s\n' '--- Utilisation de la mémoire ---'
    if command -v free >/dev/null 2>&1; then
        free -h
    else
        printf '%s\n' 'Commande free indisponible.'
    fi

    printf '\n%s\n' '--- Utilisation des systemes de fichiers ---'
    df -hT -x tmpfs -x devtmpfs

    printf '\n%s\n' '--- Charge du système ---'
    if [[ -r /proc/loadavg ]]; then
        awk '{ printf "Charge moyenne (1, 5, 15 min) : %s, %s, %s\n", $1, $2, $3 }' /proc/loadavg
    else
        uptime
    fi

    printf '\nRapport généré : %s\n' "$report_file"
    printf '%s\n' '============================================================'
} | tee -a "$report_file"
write_status=$?

if (( write_status != 0 )); then
    printf "Erreur : impossible d'ecrire le rapport dans %s. Verifiez les permissions (par exemple avec sudo).\n" "$report_file" >&2
    exit "$write_status"
fi