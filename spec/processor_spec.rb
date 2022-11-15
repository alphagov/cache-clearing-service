RSpec.describe Processor do
  let(:message) { double(ack: nil, payload:) }

  before do
    allow_any_instance_of(VarnishClearer).to receive(:clear_for)
    allow_any_instance_of(FastlyClearer).to receive(:clear_for)
  end

  shared_examples "acks messages" do
    it "acks messages" do
      subject.process(message)
      expect(message).to have_received(:ack)
    end
  end

  shared_examples "doesn't clear the cache" do |path|
    it "doesn't clear the Varnish cache for #{path}" do
      expect_any_instance_of(VarnishClearer).not_to receive(:clear_for).with(path)
      subject.process(message)
    end

    it "doesn't clear the Fastly cache for #{path}" do
      expect_any_instance_of(FastlyClearer).not_to receive(:clear_for).with(path)
      subject.process(message)
    end
  end

  shared_examples "clears the cache" do |path|
    it "clears the varnish cache for #{path}" do
      expect_any_instance_of(VarnishClearer).to receive(:clear_for).with(path)
      subject.process(message)
    end

    it "clears the Fastly cache for #{path}" do
      expect_any_instance_of(FastlyClearer).to receive(:clear_for).with(path)
      subject.process(message)
    end
  end

  context "when the route is exact" do
    let(:payload) do
      {
        "base_path" => "/government/news/govuk-implements-new-cache-clearing",
        "routes" => [{ "path" => "/government/news/govuk-implements-new-cache-clearing", "type" => "exact" }],
      }
    end

    include_examples "acks messages"
    include_examples "clears the cache", "/government/news/govuk-implements-new-cache-clearing"
    include_examples "clears the cache", "/api/content/government/news/govuk-implements-new-cache-clearing"
  end

  context "when the redirect is exact" do
    let(:payload) do
      {
        "base_path" => "/government/news/govuk-implements-new-cache-clearing",
        "redirects" => [{ "path" => "/government/news/govuk-implements-new-cache-clearing", "type" => "exact" }],
      }
    end

    include_examples "acks messages"
    include_examples "clears the cache", "/government/news/govuk-implements-new-cache-clearing"
    include_examples "clears the cache", "/api/content/government/news/govuk-implements-new-cache-clearing"
  end

  context "when the route is a prefix" do
    let(:payload) do
      {
        "base_path" => "/government/news/govuk-implements-new-cache-clearing",
        "routes" => [{ "path" => "/government", "type" => "prefix" }],
      }
    end

    include_examples "acks messages"
    include_examples "doesn't clear the cache", "/government/news/govuk-implements-new-cache-clearing"
    include_examples "clears the cache", "/api/content/government/news/govuk-implements-new-cache-clearing"
  end

  context "when the redirect is a prefix" do
    let(:payload) do
      {
        "base_path" => "/government/news/govuk-implements-new-cache-clearing",
        "redirects" => [{ "path" => "/government", "type" => "prefix" }],
      }
    end

    include_examples "acks messages"
    include_examples "doesn't clear the cache", "/government/news/govuk-implements-new-cache-clearing"
    include_examples "clears the cache", "/api/content/government/news/govuk-implements-new-cache-clearing"
  end

  context "when the content has no routes or redirects" do
    let(:payload) do
      {
        "base_path" => "/test",
        "routes" => [],
        "redirects" => [],
      }
    end

    include_examples "acks messages"
    include_examples "doesn't clear the cache"
    include_examples "clears the cache", "/api/content/test"
  end

  context "when an error is raised" do
    let(:payload) do
      {
        "base_path" => "/error-cache-clearing",
        "routes" => [{ "path" => "/error-cache-clearing", "type" => "exact" }],
      }
    end
    let(:error) { FastlyClearer::FastlyCacheClearFailed.new("Non") }

    before do
      allow_any_instance_of(FastlyClearer).to receive(:clear_for)
        .and_raise(error)
    end

    it "logs the error" do
      expect(subject.logger).to receive(:error).with(error).twice
      expect(GovukError).to receive(:notify).with(error).twice
      subject.process(message)
    end
  end
end
