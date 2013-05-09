module HostStats
  
  # module LibC
  #   extend FFI::Library
  #   ffi_lib 'c'
    
  # end
  
  ##
  # This class provides the base functions required to write a probe
  # 
  class Probe
    
    # private
      def check_error!(ret)
        if ret == -1
          raise "an error occured: #{FFI.errno()}"
        end
      end
  end
  
  class SigarProbe < Probe
    module Lib
      extend FFI::Library
      
      ffi_lib '/Users/Schmurfy/Dev/personal/sigar/src/.libs/libsigar.dylib'
    end
    
  end
  
end
