
Gem::Specification.new do |spec|
  spec.name        = 'uwaterlooapi'
  spec.version     = '0.0.1'
  spec.date        = '2014-10-25'
  spec.summary     = "UWaterlooAPI"
  spec.description = ""
  spec.authors     = ["Ankit Sardesai"]
  spec.email       = 'me@ankitsardesai.ca'
  spec.files       = `git ls-files`.split("\n")
  spec.test_files  = `git ls-files spec`.split("\n")
  spec.homepage    = 'http://rubygems.org/gems/uwaterlooapi'
  spec.license     = 'MIT'
  spec.require_paths = ['lib']
  spec.add_dependency('httparty')
  spec.add_dependency('recursive-open-struct')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('webmock')
end
