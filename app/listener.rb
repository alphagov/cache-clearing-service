class Listener
  def self.call
    logger = CacheClearingService.config.logger

    logger.info "To be implemented."

    loop do
      sleep 60
    end
  end
end
