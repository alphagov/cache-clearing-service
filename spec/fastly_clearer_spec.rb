RSpec.describe FastlyClearer do
  let(:base_path) { "/government/news/govuk-implements-new-cache-clearing" }

  subject { described_class.new(Logger.new("/dev/null")) }

  it "purges the Fastly cache for the base path in the payload" do
    url = "https://www.test.gov.uk#{base_path}"
    expect_any_instance_of(Purger).to receive(:purge).with(url)

    subject.clear_for(base_path)
  end

  context "if the Fastly cache clear fails" do
    before do
      expect_any_instance_of(Purger).to receive(:purge).and_raise(Purger::PurgeFailed.new)
    end

    it "raises an error" do
      expect {
        subject.clear_for(base_path)
      }.to raise_error(FastlyClearer::FastlyCacheClearFailed)
    end
  end
end
