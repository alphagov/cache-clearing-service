RSpec.describe FastlyClearer do
  let(:base_path) { "/government/news/govuk-implements-new-cache-clearing" }
  let(:mock_purger) { double(Purger) }

  subject { described_class.new(Logger.new("/dev/null"), mock_purger) }

  it "purges the Fastly cache for the base path in the payload, both with and without a GOV.UK account session cookie" do
    url = "https://www.test.gov.uk#{base_path}"
    expect(mock_purger).to receive(:purge).with(url)
    expect(mock_purger).to receive(:purge).with(url, { "Cookie" => "__Host-govuk_account_session=1" })

    subject.clear_for(base_path)
  end

  context "if the Fastly cache clear fails" do
    before do
      expect(mock_purger).to receive(:purge).and_raise(Purger::PurgeFailed.new)
    end

    it "raises an error" do
      expect {
        subject.clear_for(base_path)
      }.to raise_error(FastlyClearer::FastlyCacheClearFailed)
    end
  end

  context "if a full URL is provided" do
    it "clears the full URL rather than prepending the website root" do
      url = "https://assets.example.gov.uk#{base_path}"
      expect(mock_purger).to receive(:purge).with(url)
      expect(mock_purger).to receive(:purge).with(url, { "Cookie" => "__Host-govuk_account_session=1" })
      subject.clear_for(url)
    end
  end
end
