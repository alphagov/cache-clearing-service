RSpec.describe VarnishClearer do
  let(:base_path) { "/government/news/govuk-implements-new-cache-clearing" }
  let(:cache_hosts) { %w[cache-1 cache-2] }

  subject { described_class.new(Logger.new("/dev/null")) }

  before do
    allow(GovukNodes).to receive(:of_class).with("cache").and_return(cache_hosts)
  end

  it "purges the Varnish cache for the base path in the payload" do
    cache_hosts.each do |cache_host|
      url = "http://#{cache_host}:7999#{base_path}"
      expect_any_instance_of(Purger).to receive(:purge).with(url)
    end

    subject.clear_for(base_path)
  end

  context "if the Varnish cache clear fails" do
    before do
      expect_any_instance_of(Purger).to receive(:purge).and_raise(Purger::PurgeFailed.new)
    end

    it "raises an error" do
      expect {
        subject.clear_for(base_path)
      }.to raise_error(VarnishClearer::VarnishCacheClearFailed)
    end
  end
end
