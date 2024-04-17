#!/bin/sh

# Aktualisiere das Git-Repository zum Main-Branch
echo "Pull Update"
git pull origin main

# Installiere die erforderlichen Python-Abhängigkeiten
echo "Install Requirements"
pip install -r requirements.txt

# Starte das Python-Skript
echo "Start Bot"
python bot.py
