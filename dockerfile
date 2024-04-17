# Verwende das offizielle Python-Image als Basis
FROM python:3.9-slim

# Setze die Zeitzone
ENV TZ=Europe/Berlin

# Installiere Git
RUN apt-get update && apt-get install -y git

# Setze das Arbeitsverzeichnis im Container
WORKDIR /app

# Clone das Git-Repository
RUN git clone https://github.com/DjQuro/WAO-Channel-Bot.git .

# Installiere die erforderlichen Python-Abhängigkeiten
RUN pip install -r requirements.txt

# Definiere den Befehl, der ausgeführt wird, wenn der Container gestartet wird
CMD ["sh", "start.sh"]

