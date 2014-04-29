# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chinook/version'

Gem::Specification.new do |spec|
  spec.name          = 'captainu-chinook'
  spec.version       = Chinook::VERSION
  spec.authors       = ['Ben Kreeger']
  spec.email         = ['ben@captainu.com']
  spec.summary       = %q{Abstraction of Capistrano v2 deployment tasks.}
  spec.homepage      = 'https://github.com/captainu/chinook'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'capistrano', '~> 2.15.5'
  spec.add_runtime_dependency 'tinder', '~> 1.9.4'
  spec.add_runtime_dependency 'slack-notifier', '~> 0.4.1'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
end
