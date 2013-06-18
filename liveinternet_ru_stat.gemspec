Gem::Specification.new do |s|
  s.name        = 'liveinternet_ru_stat'
  s.version     = '0.1.0'
  s.date        = '2013-06-17'
  s.summary     = 'liveinternet.ru stat wrapper'
  s.description = "Wrappers for liveinternet.ru stat service"
  s.authors     = ["Eugeniy Belyaev"]
  s.email       = 'eugeniy.b@garin-studio.ru'
  s.files       = ['lib/liveinternet_ru_stat.rb']
  s.homepage    = 'https://github.com/zhekanax/liveinternet_ru_stat'

  s.add_runtime_dependency 'nokogiri', '> 1.5.0'
end
