class Processor
  def initialize
    @logger = CacheClearingService.config.logger
  end

  def process(message)
    logger.info "Received: #{message}"

    message.ack
  end

private

  attr_reader :logger
end
