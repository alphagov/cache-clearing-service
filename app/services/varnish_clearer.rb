class VarnishClearer
  def initialize(logger)
    @logger = logger
    @purger = Purger.new(logger)
  end

  def clear_for(base_path)
    GovukStatsd.time("purge.varnish") do
      GovukNodes.of_class("cache").each do |cache_hostname|
        purger.purge("http://#{cache_hostname}:7999#{base_path}")
      rescue Purger::PurgeFailed => e
        raise VarnishCacheClearFailed, e
      end
    end
  end

private

  attr_reader :logger, :purger

  class VarnishCacheClearFailed < StandardError; end
end
