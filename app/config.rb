require "json"
require "pathname"

class Config
  def initialize(environment)
    @environment = environment || "development"
  end

  attr_reader :environment

  def app_root
    @app_root ||= Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), "..")))
  end

  def logger
    @logger ||= begin
      formatter = proc do |_severity, datetime, _progname, msg|
        JSON.dump("@timestamp" => datetime.iso8601, message: msg) + "\n"
      end

      Logger.new(STDOUT, formatter: formatter)
    end
  end

private

  def log_path
    File.join(app_root, "log", "#{environment}.log")
  end
end
