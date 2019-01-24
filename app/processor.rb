require "net/http"
require "lib/govuk_nodes"
require "thwait"

class Processor
  attr_reader :logger

  def initialize
    @logger = CacheClearingService.config.logger
    @varnish_clearer = VarnishClearer.new(logger)
    @fastly_clearer = FastlyClearer.new(logger)
  end

  def process(message)
    if should_purge?(message.payload)
      threads = paths_for(content_item: message.payload).map do |path|
        Thread.new(path) { |p| purge_path(p) }
      end

      ThreadsWait.all_waits(*threads)
    end

    message.ack
  end

  def purge_path(path)
    GovukStatsd.time("purge.all") do
      varnish_clearer.clear_for(path)
      fastly_clearer.clear_for(path)
    end
  rescue StandardError => e
    logger.error(e)
    GovukError.notify(e)
  end

  def paths_for(content_item:)
    routes_and_redirects_for(content_item: content_item) \
      + content_api_paths_for(content_item: content_item)
  end

private

  attr_reader :fastly_clearer, :varnish_clearer

  def should_purge?(content_item)
    updated_at = content_item["updated_at"]
    return true unless updated_at

    delta = Time.now - Time.iso8601(updated_at)
    delta < 60 * 60 # 1 hour
  end

  def routes_and_redirects_for(content_item:)
    routes = content_item.fetch("routes", [])
    redirects = content_item.fetch("redirects", [])

    (routes + redirects)
      .select { |route| route.fetch("type") == "exact" }
      .map { |route| route.fetch("path") }
  end

  def content_api_paths_for(content_item:)
    base_path = content_item["base_path"]
    base_path ? ["/api/content#{base_path}"] : []
  end
end
