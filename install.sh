#!/bin/bash

# Funktion zum Generieren der docker-compose.yml Datei für eine Instanz
generate_docker_compose() {
    local name="$1"
    local bot_token="$2"
    local public_chat="$3"
    local announce_interval="$4"
    local public_djs="$5"

    cat <<EOF >docker-compose-$name.yml
version: '3'
services:
  wao-channel-bot-$name:
    image: quroneko/wao-channel-bot
    environment:
      - BOT_TOKEN=$bot_token
      - PUBLIC_CHAT=$public_chat
      - MESSAGE_FORMAT=${MESSAGE_FORMAT:-Markdown}
      - ANNOUNCE_INTERVAL=${announce_interval:-30}
      - MESSAGE_TEXT=${MESSAGE_TEXT:-'Meine Sendung {show} auf {station} startet am {startTime} Uhr'}
      - BASE_URL=${BASE_URL:-'https://api.weareone.fm/v1/showplan/{station}/1'}
      - PUBLIC_DJS=$public_djs
    volumes:
      - /opt/wao-channel-bot:/app
EOF
}

# Einrichten der Umgebungsvariablen für jede Instanz
read -p "Möchtest du eine weitere Instanz hinzufügen? (ja/nein): " add_instance

while [ "$add_instance" = "ja" ]; do
    read -p "Bitte gib den Namen für die Instanz ein: " name
    read -p "Bitte gib den BOT_TOKEN für die Instanz '$name' ein: " bot_token
    read -p "Bitte gib die PUBLIC_CHAT ID für die Instanz '$name' ein: " public_chat
    read -p "Bitte gib das gewünschte Ankündigungsintervall in Minuten für die Instanz '$name' ein (Standard: 30): " announce_interval
    read -p "Bitte gib die Liste der öffentlichen DJs für die Instanz '$name' ein (getrennt durch Komma): " public_djs

    # Generiere die docker-compose.yml Datei für die Instanz
    generate_docker_compose "$name" "$bot_token" "$public_chat" "$announce_interval" "$public_djs"

    read -p "Möchtest du eine weitere Instanz hinzufügen? (ja/nein): " add_instance
done

# Repository klonen und Container starten
git clone https://github.com/DjQuro/WAO-Channel-Bot /opt/wao-channel-bot
chmod +x $(find /opt/wao-channel-bot -type f -name "*.sh")

# Starte die Container für alle Instanzen
for file in docker-compose-*.yml; do
    docker-compose -f "$file" up -d
done
