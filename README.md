# WAO-Channel-Bot

Use it in Docker using
```docker pull quroneko/wao-channel-bot:latest```

Example .env included!

.env
```
BOT_TOKEN=<BOT_TOKEN>
PUBLIC_CHAT=<ChannelID>
MESSAGE_FORMAT=Markdown
ANNOUNCE_INTERVAL=30 # In Minutes!
MESSAGE_TEXT=Meine Sendung {show} auf {station} startet am {startTime} Uhr
BASE_URL=https://api.weareone.fm/v1/showplan/{station}/1
PUBLIC_DJS=DJ1,DJ2,DJ3  # Comma Seperated!
```
