MRuby::Gem::Specification.new('host-stats') do |spec|
  spec.license = 'MIT'
  spec.authors = 'Julien Ammous'
  
  # spec.rbfiles = Dir[File.expand_path('../lib/host-stats/**/*.rb', __FILE__)]
  spec.rbfiles = [
    File.expand_path('../lib/host-stats/probe.rb', __FILE__)
  ]
end
