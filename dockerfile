# Dockerfile

# Verwende das offizielle Python-Image als Basis
FROM python:3.9-slim

# Setze das Arbeitsverzeichnis im Container
WORKDIR /app

# Kopiere die Skriptdateien und die Konfiguration in das Arbeitsverzeichnis
COPY . /app

# Installiere die erforderlichen Python-Abhängigkeiten
RUN pip install requests

# Definiere den Befehl, der ausgeführt wird, wenn der Container gestartet wird
CMD ["python", "bot.py"]
