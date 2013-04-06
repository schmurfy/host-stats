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
            :number,  :uint64,
            :size,    :uint64,
            :data,    :pointer
          )
      end
      
      # SIGAR_DECLARE(int) sigar_cpu_list_get(sigar_t *sigar, sigar_cpu_list_t *cpulist);
      attach_function :sigar_cpu_list_get, [:pointer, :pointer], :int
      
      # SIGAR_DECLARE(int) sigar_cpu_get(sigar_t *sigar, sigar_cpu_t *cpu);
      attach_function :sigar_cpu_get, [:pointer, :pointer], :int
    end
    
    class Cpu < SigarProbe
      def list()
        cpus = Lib::CpuListStruct.new
        libcall('sigar_cpu_list_get', cpus.addr)
        
        arr = FFI::Pointer.new(Lib::CpuStruct, cpus[:data])
        
        res = ["cpu.global"]
        
        0.upto(cpus[:number] - 1).each do |n|
          res << "cpu.#{n}"
        end
        
        res
      end

      
      def query(resource_name)
        if resource_name == 'cpu.global'
          query_global()
          
        elsif resource_name.start_with?('cpu.')
          n = resource_name[4..-1].to_i
          query_core(n)
        else
          nil
        end
      end
      
    private
      def convert_cpu_result(cpu)        
        cpu.members.inject({}) do |ret, key|
          ret[key] = (cpu[key].to_f / cpu[:total]) * 100
          ret
        end
      end
      
      def query_global()
        cpu = Lib::CpuStruct.new
        libcall('sigar_cpu_get', cpu.addr)
        convert_cpu_result(cpu)
      end
      
      
      def query_core(n)
        cpus = Lib::CpuListStruct.new
        check_error!(
            Lib::sigar_cpu_list_get(@sigar, cpus.addr)
          )
        
        arr = FFI::Pointer.new(Lib::CpuStruct, cpus[:data])
        
        cpu = Lib::CpuStruct.new(arr[n].addr)
        convert_cpu_result(cpu)
      end
    
    end
    
  end
end
