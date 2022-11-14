require "open-uri"

class GovukNodes
  class CarrenzaFetcher
    def hostnames_of_class(node_class)
      instances_of_class(node_class).map do |instance|
        instance.fetch("name")
      end
    end

  private

    def instances_of_class(node_class)
      url = "#{puppetdb_node_url}?#{query_string(node_class)}"
      headers = {
        "Accept" => "application/json",
        "User-Agent" => "cache-clearing-service",
      }

      json_response = URI.parse(url).read(headers)
      JSON.parse(json_response)
    end

    def query_string(node_class)
      hyphenated_node_class = node_class.tr("_", "-")
      query = %(["or", ["~", ["fact", "fqdn"], "^#{hyphenated_node_class}-\\\\d+\\\\."]])

      URI.encode_www_form(query:)
    end

    def puppetdb_node_url
      @puppetdb_node_url ||= ENV["PUPPETDB_NODE_URL"]
    end
  end
end
