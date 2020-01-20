Gem::Specification.new do |s|
  s.name = 'rav-meser-api'
  s.version     = '1.0.13'
  s.date        = '2019-10-06'
  s.summary     = 'Rav Meser API'
  s.description = 'Rav Meser API Ruby'
  s.authors     = ['Ynon Perek']
  s.email       = 'ynon@ynonperek.com'
  s.files       = ['lib/rav-meser-api.rb']
  s.add_runtime_dependency 'json', '~> 2.2'
  s.add_runtime_dependency 'oauth', '~> 0.5.4'
  s.add_development_dependency 'json', '~> 2.2'
  s.add_development_dependency 'oauth', '~> 0.5.4'
  s.add_development_dependency 'pry', '~> 0.10.3'
  s.add_development_dependency 'rake', '~> 12.3.2'
  s.add_development_dependency 'minitest', '~> 5.10.3'
  s.homepage    =
    'http://rubygems.org/gems/rav-meser-api'
  s.license = 'MIT'
end
