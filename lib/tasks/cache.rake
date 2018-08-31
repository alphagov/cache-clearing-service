namespace :cache do
  desc "Clear cache for a given base path"
  task :clear, [:base_path] do |_, args|
    clearer = VarnishClearer.new(Logger.new(STDOUT))
    clearer.clear_for(args[:base_path])
  end
end
