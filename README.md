# Tgbot

A simple Telegram bot on Crystal (http://crystal-lang.org/).

## Installation

You need Crystal 0.20 or Docker.

## Environment variables

* `APP_TOKEN` A authentication token. https://core.telegram.org/bots/api#authorizing-your-bot
* `APP_CHAT_ID` A chat id (or a user id), who will receive messages from the bot. https://core.telegram.org/bots/api#chat

## Usage

Starting via Crystal:
```
crystal build src/tgbot.cr --release
APP_TOKEN=xxx APP_CHAT_ID=xxx ./tgbot
```

Starting via Docker:
```
docker build -t tgbot .
docker run -e APP_TOKEN=xxx -e APP_CHAT_ID=xxx tgbot
```

You can submit JSON-message to the bot.

`echo '{"text": "Hello, dude!"}' | nc 127.0.0.1 12800`

