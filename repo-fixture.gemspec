$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'repo-fixture/version'  

Gem::Specification.new do |s|
  s.name     = "repo-fixture"
  s.version  = ::RepoFixture::VERSION
  s.authors  = ["Cameron Dutro"]
  s.email    = ["camertron@gmail.com"]
  s.homepage = "http://github.com/camertron"

  s.description = s.summary = "Build and package up git repositories as test fixtures."

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.add_dependency 'tmp-repo', '~> 1.0.1'
  s.add_dependency 'rubyzip', '~> 1.1.0'

  s.require_path = 'lib'
  s.files = Dir["{lib,spec}/**/*", "Gemfile", "History.txt", "README.md", "Rakefile", "repo-fixture.gemspec"]
end
