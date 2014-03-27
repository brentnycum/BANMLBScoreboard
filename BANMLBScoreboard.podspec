Pod::Spec.new do |spec|
  spec.name = 'BANMLBScoreboard'
  spec.version = '0.0.1'
  spec.authors = {'Brent Nycum' => 'brentnycum@gmail.com'}
  spec.homepage = 'https://github.com/brentnycum/BANMLBScoreboard'
  spec.summary = "MLB Scoreboard downloader."
  spec.source = {:git => 'https://github.com/brentnycum/BANMLBScoreboard.git'}
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.requires_arc = true
  spec.source_files = 'BANMLBScoreboard'

  spec.dependency 'AFNetworking', '~> 2.2'

  spec.ios.deployment_target = '6.0'
  spec.osx.deployment_target = '10.8'
end