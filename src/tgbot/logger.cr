require "logger"

module Tgbot::Logger
  extend self

  def error(message, file = __FILE__, line = __LINE__)
    logger.error("#{short_path(file)}:#{line} #{message}")
  end

  def fatal(message, file = __FILE__, line = __LINE__)
    logger.fatal("#{short_path(file)}:#{line} #{message}")
  end

  private def logger
    @@logger ||= ::Logger.new(STDOUT)
  end

  private def short_path(file)
    dirname = File.expand_path("..", __DIR__)
    file.gsub("#{dirname}/", "")
  end
end
