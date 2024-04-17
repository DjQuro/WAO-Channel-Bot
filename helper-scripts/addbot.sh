#!/bin/bash

# Funktion zum Generieren der docker-compose.yml Datei
generate_docker_compose() {
    local name="$1"

    echo "version: '3'"
    echo "services:"
    echo "  wao-channel-bot-$name:"
    echo "    image: quroneko/wao-channel-bot"
    echo "    environment:"
    echo "      - BOT_TOKEN=${BOT_TOKEN}"
    echo "      - PUBLIC_CHAT=${PUBLIC_CHAT}"
    echo "      - MESSAGE_FORMAT=${MESSAGE_FORMAT:-Markdown}"
    echo "      - ANNOUNCE_INTERVAL=${ANNOUNCE_INTERVAL}"
    echo "      - MESSAGE_TEXT=${MESSAGE_TEXT:-'Meine Sendung {show} auf {station} startet am {startTime} Uhr'}"
    echo "      - BASE_URL=${BASE_URL:-'https://api.weareone.fm/v1/showplan/{station}/1'}"
    echo "      - PUBLIC_DJS=${PUBLIC_DJS}"
    echo "    volumes:"
    echo "      - /opt/wao-channel-bot:/app"
}

# Einrichten der Umgebungsvariablen
read -p "Bitte gib den BOT_TOKEN ein: " BOT_TOKEN
read -p "Bitte gib die PUBLIC_CHAT ID ein: " PUBLIC_CHAT
read -p "Bitte gib das gewünschte Ankündigungsintervall in Minuten ein (Standard: 30): " ANNOUNCE_INTERVAL
ANNOUNCE_INTERVAL=${ANNOUNCE_INTERVAL:-30}
read -p "Bitte gib die Liste der öffentlichen DJs ein (getrennt durch Komma): " PUBLIC_DJS
read -p "Bitte gib den Namen für den Service ein: " service_name

# Generiere die docker-compose.yml Datei
generate_docker_compose "$service_name" >docker-compose.yml

# Repository klonen und Container starten
docker-compose up -d
