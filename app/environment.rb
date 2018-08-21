require_relative "config"

module CacheClearingService
  def self.config
    Config.new(ENV["GOVUK_ENV"])
  end
end

$LOAD_PATH << CacheClearingService.config.app_root

require "bundler/setup"
Bundler.require(:default, CacheClearingService.config.environment)

require "govuk_app_config"

CacheClearingService.config.logger.level = Logger::DEBUG

Dir.glob("app/**/*.rb").each { |r| require r }
