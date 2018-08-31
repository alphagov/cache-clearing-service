class FastlyClearer
  def initialize(logger)
    @logger = logger
    @purger = Purger.new(logger)
  end

  def clear_for(base_path)
    purger.purge("#{website_root}#{base_path}")
  rescue Purger::PurgeFailed => e
    raise FastlyCacheClearFailed, e
  end

private

  attr_reader :logger, :purger

  def website_root
    @website_root ||= Plek.new.website_root
  end

  class FastlyCacheClearFailed < StandardError; end
end
