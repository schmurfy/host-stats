module HostStats
  
  module LibC
    extend FFI::Library
    ffi_lib 'c'
    
    attach_function :sysctlbyname, [:string, :pointer, :pointer, :pointer, :size_t], :int
  end
  
  ##
  # This class provides the base functions required to write a probe
  # 
  class Probe
    def read_sysctl(name, expected_return = :int)
      out = FFI::MemoryPointer.new(expected_return)
      len = FFI::MemoryPointer.new(:size_t)
      len.write_int(out.size)
      
      check_error!(
          LibC.sysctlbyname(name, out, len, nil, 0)
        )
      
      out.send("read_#{expected_return}")
    end
    
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
