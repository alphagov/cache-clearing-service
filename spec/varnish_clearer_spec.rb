RSpec.describe VarnishClearer do
  let(:base_path) { "/government/news/govuk-implements-new-cache-clearing" }

  let(:cache_hosts) {
    %w[
      cache-1
      cache-2
    ]
  }

  subject { described_class.new(Logger.new("/dev/null")) }

  before do
    allow(GovukNodes).to receive(:of_class).with("cache").and_return(cache_hosts)
    stub_request(:purge, /cache/)
  end

  it "purges the varnish cache for the base path in the payload" do
    subject.clear_for(base_path)

    cache_hosts.each do |cache_host|
      url = "http://#{cache_host}:7999#{base_path}"
      expect(a_request(:purge, url)).to have_been_made.once
    end
  end

  context "if the varnish cache clear fails" do
    before do
      stub_request(:purge, /cache/).to_return(status: 500)
    end

    it "raises an error" do
      expect {
        subject.clear_for(base_path)
      }.to raise_error(VarnishClearer::VarnishCacheClearFailed)
    end
  end
end
