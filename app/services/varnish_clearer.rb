class VarnishClearer
  def initialize(logger)
    @logger = logger
  end

  def clear_for(base_path)
    GovukNodes.of_class("cache").each do |cache_hostname|
      purge(base_path, cache_hostname)
    end
  end

private

  attr_reader :logger

  def purge(base_path, cache_hostname)
    url = "http://#{cache_hostname}:7999#{base_path}"
    logger.info("Purging `#{url}`")

    uri = URI(url)

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
      response = http.request(PurgeRequest.new(url))
      status = response.code.to_i

      unless (200...299).cover?(status)
        raise VarnishCacheClearFailed.new("Received #{status} for `#{url}`")
      end
    end
  end

  class PurgeRequest < Net::HTTPRequest
    METHOD = "PURGE".freeze
    REQUEST_HAS_BODY = false
    RESPONSE_HAS_BODY = true
  end

  class VarnishCacheClearFailed < StandardError; end
end
