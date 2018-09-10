require_relative "govuk_nodes/aws_fetcher"
require_relative "govuk_nodes/carrenza_fetcher"

class GovukNodes
  CACHE_TIME = (60 * 5) # 5 minutes

  def self.of_class(node_class)
    if (cached_nodes = cached_nodes_for_class(node_class))
      cached_nodes
    else
      nodes = self.new.of_class(node_class)
      cache(nodes, node_class)
      nodes
    end
  end

  def self.cached_nodes_for_class(node_class)
    return unless @cached_nodes&.has_key?(node_class)

    (nodes, cached_at) = @cached_nodes.fetch(node_class)
    still_fresh = (Time.now.to_i - cached_at) < CACHE_TIME

    return nodes if still_fresh
  end

  def self.cache(nodes, node_class)
    @cached_nodes ||= {}
    @cached_nodes[node_class] = [nodes, Time.now.to_i]
  end

  def self.clear_cache
    @cached_nodes = {}
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
