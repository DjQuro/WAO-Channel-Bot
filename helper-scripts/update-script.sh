#!/bin/bash

# Stoppe nur Container mit "wao-channel-bot" im Namen
docker ps -aqf "name=wao-channel-bot" | xargs docker stop

# Wechsle in das Verzeichnis des Repositorys
cd /opt/wao-channel-bot

# Aktualisiere den Code mit Git pull
git pull

# Installiere die eventuell neuen Python-Abhängigkeiten
pip install -r requirements.txt

# Starte die aktualisierten Container
docker-compose up -d
