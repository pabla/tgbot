require "socket"
require "json"
require "./telegram/api"
require "./server/handler"

class Tgbot::Server
  def initialize(port : Int32)
    server = TCPServer.new(port)
    puts "Listening #{port}..."
    loop do
      socket = server.accept
      spawn do
        handle(socket)
      end
    end
  end

  private def receive_message(socket)
    buf = String.build do |buf|
      loop do
        line = socket.gets
        break if line.nil? || line == "\n"
        buf << line
      end
    end
    Message.from_json(buf)
  end

  private def handle(socket)
    begin
      message = receive_message(socket)
      spawn do
        Handler.handle message
      end
    rescue e : JSON::ParseException
      Tgbot::Logger.error(e)
      socket.puts "I don't understand."
    end
    socket.close
  end
end
