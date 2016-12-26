require "./tgbot/logger"
require "./tgbot/server"
require "./tgbot/telegram/watcher"

module Tgbot; end

unless ENV.keys.includes? "APP_TOKEN"
  Tgbot::Logger.fatal("No env variable APP_TOKEN.")
  exit 1
end

unless ENV.keys.includes? "APP_CHAT_ID"
  Tgbot::Logger.fatal("No env variable APP_CHAT_ID.")
  exit 1
end

spawn do
  Tgbot::Telegram::Watcher.new
end

spawn do
  Tgbot::Server.new(12800)
end

sleep
