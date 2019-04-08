class FastlyClearer
  def initialize(logger)
    @logger = logger
    @purger = Purger.new(logger)
  end

  def clear_for(base_path_or_url)
    GovukStatsd.time("purge.fastly") do
      purger.purge(full_url(base_path_or_url))
    end
  rescue Purger::PurgeFailed => e
    raise FastlyCacheClearFailed, e
  end

private

  attr_reader :logger, :purger

  def website_root
    @website_root ||= Plek.new.website_root
  end

  def full_url(base_path_or_url)
    if base_path_or_url.start_with?("http")
      base_path_or_url
    else
      "#{website_root}#{base_path_or_url}"
    end
  end

  class FastlyCacheClearFailed < StandardError; end
end
