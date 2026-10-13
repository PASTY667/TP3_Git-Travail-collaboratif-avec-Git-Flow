#!/bin/bash

if [ -z "$1" ]; then
    echo "Manque l'adresse cible" >&2
    exit 1
fi

ip a > network_check.txt
ping -c 3 "$1" >> network_check.txt