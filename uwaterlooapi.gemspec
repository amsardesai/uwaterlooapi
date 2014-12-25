# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uwaterlooapi/version'

Gem::Specification.new do |spec|
  spec.name          = 'uwaterlooapi'
  spec.version       = UWaterlooAPI::VERSION
  spec.authors       = ['Ankit Sardesai']
  spec.email         = ['amsardesai@gmail.com']
  spec.summary       = %q{Ruby Gem wrapper for the University of Waterloo Open Data API}
  spec.description   = %q{Ruby Gem wrapper for the University of Waterloo Open Data API.}
  spec.homepage      = ''
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency 'httparty'
  spec.add_dependency 'recursive-open-struct'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
end
