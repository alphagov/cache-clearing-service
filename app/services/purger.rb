class Purger
  def initialize(logger)
    @logger = logger
  end

  def purge(url)
    logger.info("Purging `#{url}`")

    uri = URI(url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
      response = http.request(PurgeRequest.new(url))
      status = response.code.to_i

      unless (200...299).cover?(status)
        raise PurgeFailed.new("Received #{status} for `#{url}`")
      end
    end
  end

private

  attr_reader :logger

  class PurgeRequest < Net::HTTPRequest
    METHOD = "PURGE".freeze
    REQUEST_HAS_BODY = false
    RESPONSE_HAS_BODY = true
  end

  class PurgeFailed < StandardError; end
end
