source "https://rubygems.org"

gem "aws-sdk-ec2"
gem "foreman"
gem "govuk_app_config"
gem "govuk_message_queue_consumer", github: "/alphagov/govuk_message_queue_consumer", branch: "sengi/rabbitmq_url"
gem "plek"
gem "rake"
gem "thwait"

group :development, :test do
  gem "byebug"
  gem "govuk_test"
  gem "pry"
  gem "rspec-core"
  gem "rspec-expectations"
  gem "rspec-mocks"
  gem "rubocop-govuk", "4.9.0", require: false # Trialling pre-release
end

group :test do
  gem "climate_control"
  gem "simplecov"
  gem "timecop"
  gem "webmock"
end
