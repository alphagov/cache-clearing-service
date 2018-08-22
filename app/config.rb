require 'pathname'

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
      logfile = File.open(log_path, "a")
      logfile.sync = true

      Logger.new(MultiIO.new(STDOUT, logfile), "daily")
    end
  end

private

  def log_path
    File.join(app_root, "log", "#{environment}.log")
  end

  class MultiIO
    def initialize(*targets)
      @targets = targets
    end

    def write(*args)
      @targets.each { |t| t.write(*args) }
    end

    def close
      @targets.each(&:close)
    end
  end
end
