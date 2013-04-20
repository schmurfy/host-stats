module HostStats  
  
  class SigarProbe < Probe
    module Lib
      extend FFI::Library
      
      ffi_lib '/Users/Schmurfy/Dev/personal/sigar/src/.libs/libsigar.dylib'
      
      # SIGAR_DECLARE(int) sigar_open(sigar_t **sigar);
      attach_function :sigar_open, [:pointer], :int
      
      # SIGAR_DECLARE(int) sigar_close(sigar_t *sigar);
      attach_function :sigar_close, [:pointer], :int
    end
    
    def initialize
      sigar = FFI::MemoryPointer.new(:pointer)
      Lib::sigar_open(sigar)
      @sigar = sigar.get_pointer(0)
      
      if Object.const_defined?('ObjectSpace')
        ObjectSpace.define_finalizer(@sigar, SigarProbe.finalize(@sigar))
      end
    end
    
    def self.finalize(ptr)
      ->{ Lib::sigar_close(ptr) }
    end
  
  protected
    def libcall(name, *args)
      check_error!(
          Lib.send(name, @sigar, *args)
        )
    end
  end
  
end
