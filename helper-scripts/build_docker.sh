#!/bin/bash

# Überprüfe, ob eine Commit-Nachricht angegeben wurde
if [ -z "$1" ]; then
    echo "Bitte gib eine Commit-Nachricht an."
    exit 1
fi

# Setze Umgebungsvariablen
IMAGE_NAME="wao-channel-bot"
DOCKER_REPO="quroneko/wao-channel-bot"
GIT_REPO="https://github.com/DjQuro/WAO-Channel-Bot"
COMMIT_MESSAGE="$1"

# Füge alle Änderungen zum Git-Repository hinzu und committe sie
git add .
git commit -m "$COMMIT_MESSAGE"

# Lade die Änderungen in das Git-Repository hoch
git push origin main

# Bilde das Docker-Image
docker build --no-cache -t $IMAGE_NAME .

# Erzeuge einen eindeutigen Tag für das Image
TAG=$(date +'%Y%m%d%H%M%S')
IMAGE_TAG="$DOCKER_REPO/$IMAGE_NAME:$TAG"

# Tagge das Docker-Image mit dem eindeutigen Tag
docker tag $IMAGE_NAME $IMAGE_TAG

# Lade das Docker-Image in das Docker-Repository hoch
docker push $IMAGE_TAG

echo "Das Image wurde erfolgreich in das Docker-Repository hochgeladen: $IMAGE_TAG"
