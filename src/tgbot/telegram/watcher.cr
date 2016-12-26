require "./api"

class Tgbot::Telegram::Watcher
  def initialize
    update_id = 0
    loop do
      begin
        response = API.get_updates(update_id)
        if response.ok
          unless response.result.empty?
            update_id = response.result.last.update_id + 1
            response.result.each do |result|
              spawn handle(result)
            end
          end
        else
          Tgbot::Logger.error(response)
          sleep 5
        end
        sleep 0.1
      rescue e
        Tgbot::Logger.error(e)
      end
    end
  end

  private def handle(result : API::Result)
    if result.message.text
      chat_id = result.message.chat.id
      message = "You've said: #{result.message.text}"
      Tgbot::Telegram::API.send_message(chat_id, message)
    end
  end
end
