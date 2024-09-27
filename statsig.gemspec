# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'statsig'
  s.version     = '2.1.0'
  s.summary     = 'Statsig server SDK for Ruby'
  s.description = 'Statsig server SDK for feature gates and experimentation in Ruby'
  s.authors     = ['Statsig, Inc']
  s.email       = 'support@statsig.com'
  s.homepage    = 'https://rubygems.org/gems/statsig'
  s.license     = 'ISC'
  s.files       = Dir['lib/**/*']
  s.metadata    = {
    "source_code_uri" => "https://github.com/statsig-io/ruby-sdk",
    "documentation_uri" => "https://docs.statsig.com/server/rubySDK",
    "bug_tracker_uri" => "https://github.com/statsig-io/ruby-sdk/issues"
  }
  s.required_ruby_version = '>= 2.5.0'
  s.rubygems_version = '>= 2.5.0'
  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'webmock', '~> 3.13'
  s.add_development_dependency 'minitest', '~> 5.14.0'
  s.add_development_dependency 'minitest-reporters', '~> 1.6'
  s.add_development_dependency 'minitest-suite', '~> 0.0.3'
  s.add_development_dependency 'spy', '~> 1.0'
  s.add_development_dependency 'mutex_m', '~> 0.2.0'
  s.add_development_dependency 'tapioca', '~> 0.4.27'
  s.add_development_dependency 'sinatra', '~> 2.2'
  s.add_development_dependency 'puma', '~> 6.0'
  s.add_development_dependency 'rubocop', '~> 1.28.2'
  s.add_development_dependency 'parallel_tests', '~> 2.7'
  s.add_development_dependency 'simplecov', '~> 0.21'
  s.add_development_dependency 'simplecov-lcov', '~> 0.7.0'
  s.add_development_dependency 'simplecov-cobertura', '~> 2.1'
  s.add_runtime_dependency 'user_agent_parser', '~> 2.15.0'
  s.add_runtime_dependency 'http', '>= 4.4', '< 6.0'
  s.add_runtime_dependency 'connection_pool', '~> 2.4', '>= 2.4.1'
  s.add_runtime_dependency 'ip3country', '~> 0.2.1'
  s.add_runtime_dependency 'concurrent-ruby', '~> 1.1'
  s.add_runtime_dependency 'zlib', '~> 3.1.0'
end
