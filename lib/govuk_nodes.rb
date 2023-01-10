require_relative "govuk_nodes/aws_fetcher"

class GovukNodes
  CACHE_TIME = (60 * 5) # 5 minutes

  def self.of_class(node_class)
    if (cached_nodes = cached_nodes_for_class(node_class))
      cached_nodes
    else
      nodes = new.of_class(node_class)
      cache(nodes, node_class)
      nodes
    end
  end

  def self.cached_nodes_for_class(node_class)
    return unless @cached_nodes&.key?(node_class)

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
    GovukStatsd.time("nodes.fetch") do
      fetcher.hostnames_of_class(node_class)
    end
  end

private

  def fetcher
    @fetcher ||= AWSFetcher.new
  end

  class MissingConfigurationError < StandardError; end
end
