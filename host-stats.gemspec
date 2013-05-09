# -*- encoding: utf-8 -*-
require File.expand_path('../lib/host-stats/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Julien Ammous"]
  gem.email         = ["schmurfy@gmail.com"]
  gem.description   = %q{Host stats library}
  gem.summary       = %q{Host stats library.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.name          = "host-stats"
  gem.require_paths = ["lib"]
  gem.version       = HostStats::VERSION
  
  gem.add_dependency 'ffi'
end
