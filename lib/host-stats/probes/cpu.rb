module HostStats
  module Probes
    
    module SigarProbe::Lib
      # typedef struct {
      #     sigar_uint64_t
      #         user,
      #         sys,
      #         nice,
      #         idle,
      #         wait,
      #         irq,
      #         soft_irq,
      #         stolen,
      #         total;
      # } sigar_cpu_t;
      class CpuStruct < FFI::Struct
        layout(
            :user,    :uint64,
            :sys,     :uint64,
            :nice,    :uint64,
            :idle,    :uint64,
            :wait,    :uint64,
            :irq,     :uint64,
            :soft_irq,:uint64,
            :stolen,  :uint64,
            :total,   :uint64
          )
      end
      
      # typedef struct {
      #     unsigned long number;
      #     unsigned long size;
      #     sigar_cpu_t *data;
      # } sigar_cpu_list_t;
      
      class CpuListStruct < FFI::Struct
        layout(
            :number,  :ulong,
            :size,    :ulong,
            :data,    :pointer
          )
      end
      
      
      # typedef struct {
      #     double user;
      #     double sys;
      #     double nice;
      #     double idle;
      #     double wait;
      #     double irq;
      #     double soft_irq;
      #     double stolen;
      #     double combined;
      # } sigar_cpu_perc_t;
      
      class CpuPerc < FFI::Struct
        layout(
            :user,      :double,
            :sys,       :double,
            :nice,      :double,
            :idle,      :double,
            :wait,      :double,
            :irq,       :double,
            :soft_irq,  :double,
            :stolen,    :double,
            :combined,  :double
          )
      end
      
      # SIGAR_DECLARE(int) sigar_cpu_list_get(sigar_t *sigar, sigar_cpu_list_t *cpulist);
      attach_function :sigar_cpu_list_get, [:pointer, :pointer], :int
      
      # SIGAR_DECLARE(int) sigar_cpu_get(sigar_t *sigar, sigar_cpu_t *cpu);
      attach_function :sigar_cpu_get, [:pointer, :pointer], :int
      
      # SIGAR_DECLARE(int) sigar_cpu_perc_calculate(sigar_cpu_t *prev, sigar_cpu_t *curr, 
      #   sigar_cpu_perc_t *perc);
      attach_function :sigar_cpu_perc_calculate, [:pointer, :pointer, :pointer], :int

    end
    
    ##
    # This probes works differently than the others, it works by comparing snapshot
    # of the cpu activity, when you create the object a cache is initialized and
    # then each time you query the value the result is compared with the latest
    # snapshot.
    # 
    # NOTE: do not call query immediately after object creation it will return a
    # structure filled with NaN
    # 
    class Cpu < SigarProbe
      def initialize()
        super
        @history = []
        
        # initialize cache
        @history[0] = query_global(false)
        list().each.with_index do |name, n|
          @history[n + 1] = query_core(n, false)
        end
      end
      
      def list()
        cpus = Lib::CpuListStruct.new
        libcall('sigar_cpu_list_get', cpus.addr)
        
        arr = FFI::Pointer.new(Lib::CpuStruct, cpus[:data])
        res = ["cpu.global"]
        
        (0.. cpus[:number]-1).each do |n|
          res << "cpu.#{n}"
        end
        
        res
      end

      
      def query(resource_name)
        if resource_name == 'global'
          query_global()
          
        elsif resource_name.start_with?('cpu.')
          n = resource_name[-1].to_i
          query_core(n)
        else
          nil
        end
      end
      
    private
      def convert_cpu_result(history_index, cpu)
        last_measure = @history[history_index]
        @history[history_index] = cpu
        
        diff = Lib::CpuPerc.new
        check_error!(
            Lib.sigar_cpu_perc_calculate(last_measure, cpu, diff)
          )
        
        diff.class.members.inject({}) do |ret, key|
          ret[key.to_s] = diff[key] * 100
          ret
        end
      end
      
      def query_global(convert = true)
        cpu = Lib::CpuStruct.new
        libcall('sigar_cpu_get', cpu.addr)
        convert ? convert_cpu_result(0, cpu) : cpu
      end
      
      
      def query_core(n, convert = true)
        cpus = Lib::CpuListStruct.new
        libcall('sigar_cpu_list_get', cpus.addr)
                
        arr = FFI::Pointer.new(Lib::CpuStruct, cpus[:data])
        
        cpu = Lib::CpuStruct.new(arr[n].addr)

        convert ? convert_cpu_result(n + 1, cpu) : cpu
      end
    
    end
    
  end
end
