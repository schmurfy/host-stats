module HostStats  
  
  class SigarProbe < Probe
    module Lib
      extend FFI::Library
      
      [
        '/Users/Schmurfy/Dev/personal/sigar/src/.libs/libsigar.dylib',
        '/usr/local/lib/libsigar.so'
      ].each do |path|
        if ::File.exist?(path)
          ffi_lib(path)
          break
        end
      end
      
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
    
    def list()
      ['default']
    end
    
    def query(resource_name)
      m = "query_#{resource_name}"
      if respond_to?(m, true)
        send(m)
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
    
    
    # helper methods to deal with sigar structures
    def divide_element(el, divider)
      if Object.const_defined?('CFunc')
        if el.is_a?(CFunc::UInt64)
          el.divide(divider)
        else
          el.value
        end
      else
        el / divider
      end
    end
    
    def struct_convert_bytes_to_kilobytes(el)
      divide_element(el, 1024)
    end
    
    def element_value(el)
      if el.respond_to?(:value)
        el.value
      else
        el
      end
    end
    
    def struct_convert_string_value(el)
      el.to_ptr.read_string()
    end
        
    def struct_to_hash(data, actions = {})
      data.class.members.inject({}) do |ret, key|
        if data.respond_to?(:element)
          el = data.element(key)
        else
          el = data[key]
        end
        
        action = actions.select{|a,keys| keys.include?(key.to_sym) }
        if action && (action.size == 1)
          action_key = action.keys[0]
          m = "struct_convert_#{action_key}"
          
          if action_key == :identity
            ret[key.to_s] = element_value(el)
          elsif respond_to?(m, true)
            ret[key.to_s] = send(m, el)
          else
            raise "unknown conversion for: #{key}"
          end
        else
          # field was ignored
        end
                    
        ret
      end

    end
    
  end
  
end
