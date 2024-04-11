# Python-Skript (bot.py)

import os
import json
import logging
import sys
import time
import urllib
import urllib.parse
from datetime import datetime, timedelta
from pathlib import Path

import requests

# Laden der Konfiguration aus Umgebungsvariablen
config = {
    "bot_token": os.environ.get("BOT_TOKEN"),
    "publicChat": os.environ.get("PUBLIC_CHAT"),
    "message_format": os.environ.get("MESSAGE_FORMAT", "Markdown"),
    "announce_interval": int(os.environ.get("ANNOUNCE_INTERVAL", 30)),
    "message_text": os.environ.get("MESSAGE_TEXT", "Meine Sendung {show} auf {station} startet am {startTime} Uhr"),
    "base_url": os.environ.get("BASE_URL", "https://api.weareone.fm/v1/showplan/{station}/1"),
    "public_djs": os.environ.get("PUBLIC_DJS", "").split(",")  # Liste der öffentlichen DJs
}

# Logger initialisieren
logger = logging.getLogger()
logger.setLevel(logging.INFO)
formatter = logging.Formatter('[ %(asctime)s - %(levelname)s ] %(message)s')

stdout_handler = logging.StreamHandler(sys.stdout)
stdout_handler.setLevel(logging.DEBUG)
stdout_handler.setFormatter(formatter)

file_handler = logging.FileHandler('logs.log')
file_handler.setLevel(logging.DEBUG)
file_handler.setFormatter(formatter)

logger.addHandler(file_handler)
logger.addHandler(stdout_handler)

# Senderfunktion für öffentliche Ankündigungen
def telegram_public_message(message):
    encoded_message = urllib.parse.quote(message)
    content = f"https://api.telegram.org/bot{config['bot_token']}/sendMessage?chat_id={config['publicChat']}&parse_mode={config['message_format']}&text={encoded_message}"
    requests.get(content)

# Create the base URL string
base_url = config['base_url']
stations = {}

# Create the base URL string
with open("stations.json") as f:
    json_string = f.read()
stationlist = json.loads(json_string)

base_url = config['base_url']
stations = stationlist["stations"]
stationCount = 0
for station, id in stations.items():
    stationCount = stationCount + 1

#NUR FÜR DICH, AYBEE! <3
def remaining_minutes(start_time):
    current_time = datetime.datetime.now()
    delta = start_time - current_time
    return int(delta.total_seconds() / 60)

def check():
    try:
        global current_time, status
        # Iterate over the stations in the dictionary
        for station, id in stations.items():
            # Use string formatting to insert the station ID into the URL
            endpoint_url = base_url.format(station=id)
            now = time.time()
            current_time = datetime.fromtimestamp(now).strftime("%d.%m.%Y %H:%M")
            # Send a GET request to the generated Endpoint
            response = requests.get(endpoint_url)
            # Check the response status code
            status = str(response.status_code)
            if response.status_code == 200:
                logger.info(f"[{station}] STATUS {status} von {endpoint_url}")
                # Parse the JSON data from the response
                with urllib.request.urlopen(endpoint_url) as url:
                    data = json.load(url)
                cache = Path("cache/mi.json")
                if cache.is_file():
                    with open("cache/mi.json") as sentShows:
                        sentJson = sentShows.read()
                    sent = json.loads(sentJson)
                    sent = sent["sent"]
                    sentShows.close()
                else:
                    f = open(cache, 'w+')
                    f.write('{"sent": []}')
                    f.close()
                    with open("cache/mi.json") as sentShows:
                        sentJson = sentShows.read()
                    sent = json.loads(sentJson)
                    sent = sent["sent"]
                    sentShows.close()

                for x in data:
                    show = x["n"]
                    dj = x["m"]
                    startUnix = x["s"]
                    endUnix = x["e"]
                    endUnix = endUnix // 1000
                    startUnix = startUnix // 1000
                    startTime = datetime.fromtimestamp(startUnix).strftime(
                        "%d.%m.%Y um %H:%M"
                    )
                    endTime = datetime.fromtimestamp(endUnix).strftime(
                        "%H:%M"
                    )
                    startOffset = startUnix - now
                    #NUR FÜR DICH, AYBEE! <3
                    startmin = remaining_minutes(startUnix)
                    if x["m"] in config["public_djs"]
                        logger.info(f"{show} by {dj} at {station} found from {startTime} to {endTime} - {startmin} Minutes remaining") 
                    if x["m"] in config["public_djs"] and startUnix > now:
                        uid = x["mi"] + x["s"] + x["e"]
                        if config['announce_interval'] * 60 >= startOffset and uid not in sent:
                            message_text = config.get('message_text', 'Meine Sendung {show} auf {station} startet am {startTime} Uhr')
                            message = message_text.format(show=show, station=station, startTime=startTime)
                            logger.info(
                                f"Message sent: {config.get('message_text', 'Meine Sendung {show} auf {station} startet am {startTime} Uhr')} - ShowUID={uid}")
                            telegram_public_message(message)
                            sent.append(uid)
                            with open("cache/mi.json", "w") as sentShows:
                                data = {
                                    "sent": sent
                                }
                                json_string = json.dumps(data, indent=4)
                                sentShows.write(json_string)

                now = datetime.now()
                if now.hour == 0 and now.minute == 0:
                    sentFile = f"cache/mi.json"
                    sentShows = open(sentFile, 'w+')
                    sentShows.write('{"sent":[]}')
                    sentShows.close()

            else:
                logger.error(f"[{station}] FEHLER {status} von {endpoint_url}")
    except requests.exceptions.ConnectionError:
        logger.error("Verbindungsfehler aufgetreten. Versuche es erneut.")

# Startnachricht loggen
logger.info("Bot gestartet.")

# Dauerschleife mit Wartezeit
while True:
    check()
    logger.info("Waiting for 60 seconds...")
    time.sleep(60)  # Pause für 60 Sekunden
