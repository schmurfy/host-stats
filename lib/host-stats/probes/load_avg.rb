module HostStats
  module Probes
    
    module SigarProbe::Lib
      
      # typedef struct {
      #     double loadavg[3];
      # } sigar_loadavg_t;
      #
      class LoadAvgStruct < FFI::Struct
        layout(
            :min1,           :double,
            :min5,           :double,
            :min15,          :double
          )
      end
      
      # SIGAR_DECLARE(int) sigar_loadavg_get(sigar_t *sigar, sigar_loadavg_t *loadavg);
      attach_function :sigar_loadavg_get, [:pointer, :pointer], :int
    end
    
    class LoadAvg < SigarProbe
      def query(_)
        loadavg = Lib::LoadAvgStruct.new
        libcall('sigar_loadavg_get', loadavg.addr)
        
        ret = struct_to_hash(loadavg,
            :identity => [:min1, :min5, :min15]
          )
        
        ret
      end
      
    end
    
  end
end
