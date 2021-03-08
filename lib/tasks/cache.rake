namespace :cache do
  desc "Clear Varnish cache for a given base path"
  task :clear_varnish, [:base_path] do |_, args|
    clearer = VarnishClearer.new(Logger.new($stdout))
    clearer.clear_for(args[:base_path])
  rescue StandardError => e
    puts "clear_varnish: error: #{e}"
  end

  desc "Clear Fastly cache for a given base path or URL"
  task :clear_fastly, [:base_path_or_url] do |_, args|
    clearer = FastlyClearer.new(Logger.new($stdout))
    clearer.clear_for(args[:base_path_or_url])
  rescue StandardError => e
    puts "clear_fastly: error: #{e}"
  end

  desc "Clear cache for a given base path"
  task :clear, [:base_path] do |_, args|
    Rake::Task["cache:clear_varnish"].invoke(args[:base_path])
    Rake::Task["cache:clear_fastly"].invoke(args[:base_path])
  end
end
