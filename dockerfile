# Verwende das offizielle Python-Image als Basis
FROM python:3.9-slim

# Setze die Zeitzone
ENV TZ=Europe/Berlin

# Setze das Arbeitsverzeichnis im Container
WORKDIR /app

# Kopiere die Skriptdateien in das Arbeitsverzeichnis
COPY bot.py .
COPY start.sh .

# Installiere die erforderlichen Python-Abhängigkeiten
RUN pip install requests

# Definiere den Befehl, der ausgeführt wird, wenn der Container gestartet wird
CMD ["sh", "start.sh"]

