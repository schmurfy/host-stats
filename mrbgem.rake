LIB_ROOT = File.expand_path('../lib/host-stats', __FILE__)

MRBFILES = [
    File.join(LIB_ROOT, 'mruby.rb'),
    File.join(LIB_ROOT, 'probe.rb'),
    File.join(LIB_ROOT, 'sigar_probe.rb'),
    File.join(LIB_ROOT, 'probes/cpu.rb')
  ]

if defined?(MRuby)
  MRuby::Gem::Specification.new('host-stats') do |spec|
    spec.license = 'MIT'
    spec.authors = 'Julien Ammous'
    
    # spec.rbfiles = Dir[File.expand_path('../lib/host-stats/**/*.rb', __FILE__)]
    spec.rbfiles = MRBFILES
  end
end
