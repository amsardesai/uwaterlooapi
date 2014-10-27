
Gem::Specification.new do |spec|
  spec.name        = 'uwaterlooapi'
  spec.version     = '0.0.1'
  spec.date        = '2014-10-26'
  spec.summary     = "Ruby Gem wrapper for the University of Waterloo Open Data API"
  spec.description = "Ruby Gem wrapper for the University of Waterloo Open Data API"
  spec.authors     = ["Ankit Sardesai"]
  spec.email       = 'me@ankitsardesai.ca'
  spec.files       = `git ls-files`.split("\n")
  spec.test_files  = `git ls-files spec`.split("\n")
  spec.homepage    = 'http://rubygems.org/gems/uwaterlooapi'
  spec.license     = 'MIT'
  spec.require_paths = ['lib']
  spec.add_runtime_dependency 'httparty'
  spec.add_runtime_dependency 'recursive-open-struct'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
end
