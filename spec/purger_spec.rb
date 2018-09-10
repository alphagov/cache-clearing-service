RSpec.describe Purger do
  let(:url) { "https://www.gov.uk/government/news/govuk-implements-new-cache-clearing" }

  subject { described_class.new(Logger.new("/dev/null")) }

  context "if the purge request succeeds" do
    before do
      stub_request(:purge, /cache/)
    end

    it "purges the cache for the base path in the payload" do
      subject.purge(url)
      expect(a_request(:purge, url)).to have_been_made.once
    end
  end

  context "if the purge request fails" do
    before do
      stub_request(:purge, /cache/).to_return(status: 500)
    end

    it "raises an error" do
      expect {
        subject.purge(url)
      }.to raise_error(Purger::PurgeFailed)
    end
  end
end
