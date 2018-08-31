source "http://rubygems.org"

gem "govuk_app_config", "~> 1.8"
gem "govuk_message_queue_consumer", "~> 3.2"
gem "rake", "~> 12.3"
gem "aws-sdk-ec2", "~> 1"

group :development, :test do
  gem "govuk-lint", "~> 3.9"
  gem "govuk_test", "~> 0.1"
  gem "rspec-core", "~> 3.8"
  gem "rspec-expectations", "~> 3.8"
  gem "rspec-mocks", "~> 3.8"
end

group :test do
  gem "climate_control"
  gem "webmock"
end
