require "net/http"
require "lib/govuk_nodes"

class Processor
  def initialize
    @logger = CacheClearingService.config.logger
    @varnish_clearer = VarnishClearer.new(logger)
    @fastly_clearer = FastlyClearer.new(logger)
  end

  def process(message)
    base_path = message.payload.fetch("base_path")

    varnish_clearer.clear_for(base_path)
    fastly_clearer.clear_for(base_path)

    message.ack
  end

private

  attr_reader :fastly_clearer, :logger, :varnish_clearer
end
