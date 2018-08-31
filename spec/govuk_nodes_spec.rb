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

    let(:fetcher_response) {
      %w[
        email_alert_api-1
      ]
    }

    it "uses the AWS fetcher" do
      expect_any_instance_of(described_class::AWSFetcher).to receive(:hostnames_of_class)
        .with(node_class).and_return(fetcher_response)

      expect(described_class.of_class(node_class)).to eq(fetcher_response)
    end
  end

  context "if the AWS flag is off" do
    let(:fetcher_response) {
      %w[
        email_alert_api-1
      ]
    }

    it "uses the Carrenza fetcher" do
      expect_any_instance_of(described_class::CarrenzaFetcher).to receive(:hostnames_of_class)
        .with(node_class).and_return(fetcher_response)

      expect(described_class.of_class(node_class)).to eq(fetcher_response)
    end
  end
end
