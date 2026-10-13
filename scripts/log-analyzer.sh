#!/usr/bin/env bash

set -o pipefail

usage() {
	printf 'Usage: %s <fichier-journal> [fichier-rapport]\n' "${0##*/}" >&2
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
	usage
	exit 2
fi

log_file=$1
if [[ ! -f "$log_file" ]]; then
	printf 'Erreur : fichier journal introuvable ou non regulier : %s\n' "$log_file" >&2
	exit 1
fi
if [[ ! -r "$log_file" ]]; then
	printf 'Erreur : fichier journal non lisible : %s\n' "$log_file" >&2
	exit 1
fi

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
project_dir=$(dirname -- "$script_dir")
report_dir=${REPORT_DIR:-}

# Lit REPORT_DIR sans sourcer le fichier de configuration, qui n'est pas un script Bash.
if [[ -z "$report_dir" && -r "$project_dir/config/toolkit.conf" ]]; then
	while IFS= read -r config_line || [[ -n "$config_line" ]]; do
		if [[ "$config_line" =~ ^[[:space:]]*REPORT_DIR[[:space:]]*=[[:space:]]*(.*)$ ]]; then
			report_dir=${BASH_REMATCH[1]}
			report_dir="${report_dir#${report_dir%%[![:space:]]*}}"
			report_dir="${report_dir%${report_dir##*[![:space:]]}}"
			break
		fi
	done < "$project_dir/config/toolkit.conf"
fi

# Les chemins relatifs de configuration sont resolus depuis la racine du projet.
if [[ -z "$report_dir" ]]; then
	report_dir="$project_dir/reports"
elif [[ "$report_dir" != /* ]]; then
	report_dir="$project_dir/$report_dir"
fi

if [[ $# -eq 2 ]]; then
	report_file=$2
else
	timestamp=$(date '+%Y%m%d-%H%M%S')
	log_name=${log_file##*/}
	report_file="$report_dir/log-analysis-${log_name}-${timestamp}.txt"
fi

report_parent=$(dirname -- "$report_file")
if ! mkdir -p -- "$report_parent"; then
	printf 'Erreur : impossible de creer le repertoire du rapport : %s\n' "$report_parent" >&2
	exit 1
fi

# Une seule passe compte les lignes et conserve les erreurs et avertissements trouves.
if ! awk -v source="$log_file" -v analyzed_at="$(date '+%Y-%m-%d %H:%M:%S %Z')" \
	-f /dev/stdin "$log_file" > "$report_file" <<'AWK'
BEGIN {
	print "Rapport d'analyse de journal"
	print "============================"
}
{
	total++
	lowered = tolower($0)
	if (lowered ~ /(^|[^[:alnum:]_])error([^[:alnum:]_]|$)/) {
		errors++
		error_lines = error_lines sprintf("Ligne %d : %s\n", NR, $0)
	}
	if (lowered ~ /(^|[^[:alnum:]_])warning([^[:alnum:]_]|$)/) {
		warnings++
		warning_lines = warning_lines sprintf("Ligne %d : %s\n", NR, $0)
	}
}
END {
	printf "Fichier analyse : %s\n", source
	printf "Date analyse : %s\n", analyzed_at
	printf "Nombre total de lignes : %d\n", total
	printf "Nombre erreurs : %d\n", errors
	printf "Nombre avertissements : %d\n\n", warnings
	print "Lignes contenant des erreurs :"
	if (errors) printf "%s", error_lines
	else print "Aucune erreur detectee."
	print ""
	print "Lignes contenant des avertissements :"
	if (warnings) printf "%s", warning_lines
	else print "Aucun avertissement detecte."
}
AWK
then
	printf 'Erreur : analyse du fichier impossible.\n' >&2
	exit 1
fi

cat -- "$report_file"
printf '\nRapport enregistre dans : %s\n' "$report_file"
