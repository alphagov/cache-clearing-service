ENV["GOVUK_ENV"] = "test"
ENV["GOVUK_APP_DOMAIN"] = "test.gov.uk"

require "simplecov"
SimpleCov.start

require_relative "../app/environment"

require "webmock/rspec"
WebMock.disable_net_connect!

Dir[File.join(CacheClearingService.config.app_root, "spec/support/**/*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:example) do
    Timecop.freeze(Time.local(1994))
  end

  config.after(:example) do
    Timecop.freeze(Time.local(1994))
    GovukNodes.clear_cache
  end
end
