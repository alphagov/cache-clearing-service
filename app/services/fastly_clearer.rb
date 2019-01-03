class FastlyClearer
  def initialize(logger)
    @logger = logger
    @purger = Purger.new(logger)
  end

  def clear_for(base_path)
    GovukStatsd.time("purge.fastly") do
      purger.purge("#{website_root}#{base_path}")
    end
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
