module HostStats
  module Probes
    
    module SigarProbe::Lib
      
      # typedef struct {
      #     sigar_uint64_t
      #         total,
      #         used, 
      #         free,
      #         page_in,
      #         page_out;
      # } sigar_swap_t;
      #
      class SwapStruct < FFI::Struct
        layout(
            :total,           :uint64,
            :used,            :uint64,
            :free,            :uint64,
            :page_in,         :uint64,
            :page_out,        :uint64
          )
      end
      
      # SIGAR_DECLARE(int) sigar_swap_get(sigar_t *sigar, sigar_swap_t *swap);
      attach_function :sigar_swap_get, [:pointer, :pointer], :int
    end
    
    class Swap < SigarProbe
      def query(_)
        swap = Lib::SwapStruct.new
        libcall('sigar_swap_get', swap.addr)
        ret = struct_to_hash(swap,
            :bytes_to_kilobytes => [:total, :used, :free],
            :identity           => [:page_in, :page_out]
          )
        
        ret['used_percent'] = (ret['used'].to_f / ret['total']) * 100.0
        ret['free_percent'] = (ret['free'].to_f / ret['total']) * 100.0
        ret
      end
      
    end
    
  end
end
