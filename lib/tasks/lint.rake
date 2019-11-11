desc "Run rubocop with similar params to CI"
task "lint" do
  sh "rubocop --format clang Gemfile app bin lib spec"
end
