RSpec.describe FastlyClearer do
  let(:base_path) { "/government/news/govuk-implements-new-cache-clearing" }

  subject { described_class.new(Logger.new("/dev/null")) }

  before do
    stub_request(:purge, /cache/)
  end

  it "purges the Fastly cache for the base path in the payload" do
    subject.clear_for(base_path)

    url = "https://www.test.gov.uk#{base_path}"
    expect(a_request(:purge, url)).to have_been_made.once
  end

  context "if the Fastly cache clear fails" do
    before do
      stub_request(:purge, /cache/).to_return(status: 500)
    end

    it "raises an error" do
      expect {
        subject.clear_for(base_path)
      }.to raise_error(FastlyClearer::FastlyCacheClearFailed)
    end
  end
end
