RSpec.describe Processor do
  context "when processing a message" do
    let(:message) { double }

    after { subject.process(message) }

    it "acks messages" do
      expect(message).to receive(:ack)
    end
  end
end
