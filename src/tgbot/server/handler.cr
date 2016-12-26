class Tgbot::Server
  struct Message
    JSON.mapping(
      text: String
    )
  end

  module Handler
    extend self

    def handle(message : Message)
      chat_id = ENV["APP_CHAT_ID"].to_i
      Tgbot::Telegram::API.send_message(chat_id, message.text)
    end
  end
end
