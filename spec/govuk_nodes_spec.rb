require "spec_helper"

require "govuk_nodes"

RSpec.describe GovukNodes do
  let(:node_class) { "email_alert_api" }
  let(:stack_name) { "green" }

  context "if the AWS flag is on" do
    around do |example|
      ClimateControl.modify AWS_STACKNAME: stack_name do
        example.run
      end
    end

    let(:fetcher_response) do
      %w[
        email_alert_api-1
      ]
    end

    let(:aws_fetcher) { double(:aws_fetcher) }

    before do
      allow(described_class::AWSFetcher).to receive(:new).and_return(aws_fetcher)
      allow(aws_fetcher).to receive(:hostnames_of_class).with(node_class)
        .and_return(fetcher_response)
    end

    it "uses the AWS fetcher" do
      expect(described_class.of_class(node_class)).to eq(fetcher_response)
    end

    it "caches node request calls for 5 minutes" do
      described_class.of_class(node_class)
      expect(aws_fetcher).to have_received(:hostnames_of_class).once

      Timecop.freeze(Time.now + (60 * 4))

      described_class.of_class(node_class)
      expect(aws_fetcher).to have_received(:hostnames_of_class).once

      Timecop.freeze(Time.now + (60 * 2))

      described_class.of_class(node_class)
      expect(aws_fetcher).to have_received(:hostnames_of_class).twice
    end
  end
end
