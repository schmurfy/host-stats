module HostStats
  module Probes
    
    module SigarProbe::Lib
      
      # typedef struct {
      #     double uptime;
      # } sigar_uptime_t;
      #
      class UptimeStruct < FFI::Struct
        layout(
            :uptime,           :double
          )
      end
      
      # SIGAR_DECLARE(int) sigar_uptime_get(sigar_t *sigar, sigar_uptime_t *uptime);
      attach_function :sigar_uptime_get, [:pointer, :pointer], :int
    end
    
    class Uptime < SigarProbe
      def query(_)
        uptime = Lib::UptimeStruct.new
        libcall('sigar_uptime_get', uptime.addr)
        ret = struct_to_hash(uptime,
            :identity => [:uptime]
          )
        
        ret
      end
      
    end
    
  end
end
