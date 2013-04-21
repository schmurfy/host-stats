
require 'ffi'

require File.expand_path('../host-stats/version', __FILE__)

RBFILES = [
  'probe',
  'sigar_probe',
  'probes/cpu',
  'probes/memory',
  'probes/load_avg',
  'probes/swap',
  'probes/uptime'
]


RBFILES.each do |path|
  require File.expand_path("../host-stats/#{path}", __FILE__)
end



# compatibility layer for CFunc
class FFI::Pointer
  def addr
    self
  end
end

class FFI::Struct
  def addr
    self
  end
end
