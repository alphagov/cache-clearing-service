require_relative "govuk_nodes/aws_fetcher"
require_relative "govuk_nodes/carrenza_fetcher"

class GovukNodes
  def self.of_class(node_class)
    self.new.of_class(node_class)
  end

  def of_class(node_class)
    fetcher.hostnames_of_class(node_class)
  end

private

  def fetcher
    @fetcher ||= aws? ? AWSFetcher.new : CarrenzaFetcher.new
  end

  def aws?
    ENV["AWS_STACKNAME"].present?
  end

  class MissingConfigurationError < StandardError; end
end
