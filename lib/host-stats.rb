
require 'ffi'

require File.expand_path('../host-stats/version', __FILE__)

require File.expand_path('../host-stats/probe', __FILE__)
require File.expand_path('../host-stats/sigar_probe', __FILE__)
require File.expand_path('../host-stats/probes/cpu', __FILE__)
require File.expand_path('../host-stats/probes/memory', __FILE__)
require File.expand_path('../host-stats/probes/load_avg', __FILE__)
require File.expand_path('../host-stats/probes/swap', __FILE__)
require File.expand_path('../host-stats/probes/uptime', __FILE__)


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
