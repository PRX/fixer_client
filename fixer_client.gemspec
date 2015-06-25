# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fixer/version'

Gem::Specification.new do |spec|
  spec.name          = 'fixer_client'
  spec.version       = Fixer::VERSION
  spec.authors       = ['Andrew Kuklewicz']
  spec.email         = ['andrew@prx.org']
  spec.summary       = %q{Client for the fixer application.}
  spec.description   = %q{Client for the fixer application.}
  spec.homepage      = 'https://github.org/PRX/fixer_client'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency('faraday')
  spec.add_runtime_dependency('faraday_middleware')
  spec.add_runtime_dependency('oauth2')
  spec.add_runtime_dependency('multi_json')
  spec.add_runtime_dependency('excon')
  spec.add_runtime_dependency('hashie')
  spec.add_runtime_dependency('activesupport')
  spec.add_runtime_dependency('aws-sdk-core')

  spec.add_development_dependency('bundler', '~> 1.3')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('minitest')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('coveralls')
  spec.add_development_dependency('webmock')
  spec.add_development_dependency('dotenv')
end
