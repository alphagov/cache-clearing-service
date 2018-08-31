require "net/http"
require "lib/govuk_nodes"

class Processor
  def initialize
    @logger = CacheClearingService.config.logger
  end

  def process(message)
    VarnishClearer.new(logger).clear_for(message.payload.fetch("base_path"))

    message.ack
  end

private

  attr_reader :logger
end
