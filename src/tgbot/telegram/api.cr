require "http/client"
require "json"

module Tgbot::Telegram::API
  extend self

  def send_message(chat_id : Int32, text : String)
    body = {
      "chat_id" => chat_id,
      "text"    => text,
    }
    execute("sendMessage", body) do |res|
      begin
        buf = res.body_io.gets_to_end
        response = ResponseMessage.from_json(buf)
        Tgbot::Logger.error(response) unless response.ok
      rescue e : JSON::ParseException
        Tgbot::Logger.error(e)
      end
    end
  end

  def get_updates(offset = 0)
    body = {
      "offset"  => offset,
      "timeout" => 30,
    }
    execute("getUpdates", body) do |res|
      buf = IO::Memory.new
      loop do
        line = res.body_io.gets
        if line
          buf << line
        else
          unless buf.empty?
            begin
              return ResponseResult.from_json(buf.to_s)
            rescue e : JSON::ParseException
              Tgbot::Logger.error(e)
              return ResponseResult.new(false, [] of Result)
            end
          else
            sleep 1
          end
        end
      end
    end
  end

  private def execute(cmd : String, body : Hash, &block)
    body = body.merge({
      "parse_mode"               => "HTML",
      "disable_web_page_preview" => true,
    })
    token = ENV["APP_TOKEN"]
    uri = URI.parse("https://api.telegram.org")
    client = HTTP::Client.new uri
    client.dns_timeout = 1.seconds
    client.connect_timeout = 10.seconds
    client.read_timeout = 60.seconds
    endpoint = "/bot#{token}/#{cmd}"
    headers = HTTP::Headers{"Content-Type" => "application/json"}
    client.post(endpoint, headers: headers, body: body.to_json) do |res|
      yield res
    end
    # client.close
  end

  struct ResponseResult
    JSON.mapping(
      ok: Bool,
      result: {type: Array(Result), default: [] of Result},
      error_code: {type: Int32, nilable: true},
      description: {type: String, nilable: true}
    )

    def initialize(ok : Bool, result : Array(Result))
      @ok = ok
      @result = result
    end
  end

  struct ResponseMessage
    JSON.mapping(
      ok: Bool,
      result: {type: Message, nilable: true},
      error_code: {type: Int32, nilable: true},
      description: {type: String, nilable: true}
    )
  end

  struct Result
    JSON.mapping(
      update_id: Int32,
      message: Message
    )
  end

  struct Message
    JSON.mapping(
      message_id: Int32,
      from: User,
      chat: Chat,
      date: Int32,
      text: {type: String, nilable: true}
    )
  end

  struct User
    JSON.mapping(
      id: Int32,
      first_name: String,
      username: String,
    )
  end

  struct Chat
    JSON.mapping(
      id: Int32,
      title: {type: String, nilable: true},
      first_name: {type: String, nilable: true},
      username: {type: String, nilable: true},
      type: String
    )
  end
end
