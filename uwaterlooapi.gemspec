Gem::Specification.new do |spec|
  spec.name        = 'uwaterlooapi'
  spec.version     = '0.0.1'
  spec.date        = '2014-10-25'
  spec.summary     = "UWaterlooAPI"
  spec.description = ""
  spec.authors     = ["Ankit Sardesai"]
  spec.email       = 'me@ankitsardesai.ca'
  spec.files       = ["lib/uwaterlooapi.rb"]
  #spec.homepage    = 'http://rubygems.org/gems/hola'
  spec.license     = 'MIT'
  spec.require_paths = ['lib']
  spec.add_dependency('httparty')
  spec.add_dependency('json')
  spec.add_dependency('yaml')
end
