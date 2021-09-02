class Purger
  def initialize(logger)
    @logger = logger
  end

  def purge(url, extra_headers = {})
    if extra_headers.empty?
      logger.info("Purging: #{url}")
    else
      logger.info("Purging: #{url} #{extra_headers}")
    end

    uri = URI(url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
      response = http.request(PurgeRequest.new(uri.request_uri, extra_headers))
      status = response.code.to_i

      unless (200...299).cover?(status)
        raise PurgeFailed, "Received #{status} for `#{url}`"
      end
    end
  end

private

  attr_reader :logger

  class PurgeRequest < Net::HTTPRequest
    METHOD = "PURGE".freeze
    REQUEST_HAS_BODY = false
    RESPONSE_HAS_BODY = true

    def initialize(*args)
      super(*args)
      self["Fastly-Soft-Purge"] = "1"
    end
  end

  class PurgeFailed < StandardError; end
end
