RSpec.describe Processor do
  let(:base_path) { "/government/news/govuk-implements-new-cache-clearing" }
  let(:payload) { { "base_path" => base_path } }
  let(:message) { double(ack: nil, payload: payload) }

  before do
    allow_any_instance_of(VarnishClearer).to receive(:clear_for)
    allow_any_instance_of(FastlyClearer).to receive(:clear_for)
  end

  it "clears the varnish cache for the base path" do
    expect_any_instance_of(VarnishClearer).to receive(:clear_for).with(base_path)
    subject.process(message)
  end

  it "clears the Fastly cache for the base path" do
    expect_any_instance_of(FastlyClearer).to receive(:clear_for).with(base_path)
    subject.process(message)
  end

  it "acks messages" do
    subject.process(message)
    expect(message).to have_received(:ack)
  end
end
