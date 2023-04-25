namespace :cache do
  desc "Clear Fastly cache for a given base path or URL"
  task :clear_fastly, [:base_path_or_url] do |_, args|
    clearer = FastlyClearer.new(Logger.new($stdout))
    clearer.clear_for(args[:base_path_or_url])
  rescue StandardError => e
    puts "clear_fastly: error: #{e}"
  end

  desc "Clear cache for a given base path"
  task :clear, [:base_path] do |_, args|
    Rake::Task["cache:clear_fastly"].invoke(args[:base_path])
  end
end
