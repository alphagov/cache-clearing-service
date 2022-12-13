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
    @logger ||= Logger.new(log_file)
  end

private

  def log_file
    if ENV["RAILS_LOG_TO_STDOUT"]
      $stdout
    else
      File.open(File.join(app_root, "log", "#{environment}.log"), "a")
    end
  end
end
