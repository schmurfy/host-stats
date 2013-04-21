module HostStats
  module Probes
    
    module SigarProbe::Lib
      # typedef struct {
      #     sigar_uint64_t
      #         ram,
      #         total,
      #         used, 
      #         free,
      #         actual_used,
      #         actual_free;
      #     double used_percent;
      #     double free_percent;
      # } sigar_mem_t;
      # 
      class MemStruct < FFI::Struct
        layout(
            :ram,           :uint64,    # megabytes
            :total,         :uint64,    # bytes
            :used,          :uint64,    # bytes
            :free,          :uint64,    # bytes
            :actual_used,   :uint64,    # bytes
            :actual_free,   :uint64,    # bytes
            :used_percent,  :double,    # percent (incorrect value)
            :free_percent,  :double     # percent (incorrect value)
          )
      end
      
      
      # SIGAR_DECLARE(int) sigar_mem_get(sigar_t *sigar, sigar_mem_t *mem);
      attach_function :sigar_mem_get, [:pointer, :pointer], :int
      
    end
    
    class Memory < SigarProbe
      
      def query(_)
        mem = Lib::MemStruct.new
        libcall('sigar_mem_get', mem.addr)
        ret = struct_to_hash(mem,
            :bytes_to_kilobytes => [:ram, :total, :used, :free, :actual_used, :actual_free],
            :identity => [:used_percent, :free_percent]
          )
        
        ret
      end
    end
    
  end 
end
