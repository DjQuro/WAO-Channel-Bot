#!/bin/sh

# Aktualisiere das Git-Repository zum Main-Branch
git pull origin main

# Installiere die erforderlichen Python-Abh�ngigkeiten
pip install -r requirements.txt

# Starte das Python-Skript
python bot.py
