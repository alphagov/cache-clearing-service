namespace :cache do
  desc "Clear Varnish cache for a given base path"
  task :clear_varnish, [:base_path] do |_, args|
    clearer = VarnishClearer.new(Logger.new(STDOUT))
    clearer.clear_for(args[:base_path])
  end

  desc "Clear Fastly cache for a given base path or URL"
  task :clear_fastly, [:base_path_or_url] do |_, args|
    clearer = FastlyClearer.new(Logger.new(STDOUT))
    clearer.clear_for(args[:base_path_or_url])
  end

  desc "Clear cache for a given base path"
  task :clear, [:base_path] => %i(clear_varnish clear_fastly)
end
