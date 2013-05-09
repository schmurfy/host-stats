
require 'ffi'

require File.expand_path('../files', __FILE__)

require File.expand_path('../host-stats/version', __FILE__)

require File.expand_path('../../ext/hoststats', __FILE__)

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
