module HostStats
  module Probes
    
    module SigarProbe::Lib
      
      # typedef enum {
      #     SIGAR_FSTYPE_UNKNOWN,
      #     SIGAR_FSTYPE_NONE,
      #     SIGAR_FSTYPE_LOCAL_DISK,
      #     SIGAR_FSTYPE_NETWORK,
      #     SIGAR_FSTYPE_RAM_DISK,
      #     SIGAR_FSTYPE_CDROM,
      #     SIGAR_FSTYPE_SWAP,
      #     SIGAR_FSTYPE_MAX
      # } sigar_file_system_type_e;
      enum :file_system_type, [
        :unknown, 0,
        :none,
        :local,
        :network,
        :ramdisk,
        :cdrom,
        :swap,
        :max 
      ]

      # #define SIGAR_FS_NAME_LEN SIGAR_PATH_MAX
      # #define SIGAR_FS_INFO_LEN 256
      
      SIGAR_FS_NAME_LEN = HostStats.maxpathlen
      SIGAR_FS_INFO_LEN = 256

      # typedef struct {
      #     char dir_name[SIGAR_FS_NAME_LEN];
      #     char dev_name[SIGAR_FS_NAME_LEN];
      #     char type_name[SIGAR_FS_INFO_LEN];     /* e.g. "local" */
      #     char sys_type_name[SIGAR_FS_INFO_LEN]; /* e.g. "ext3" */
      #     char options[SIGAR_FS_INFO_LEN];
      #     sigar_file_system_type_e type;
      #     unsigned long flags;
      # } sigar_file_system_t;
      class FSStruct < FFI::Struct
        layout(
            :dir_name,      [:uint8, SIGAR_FS_NAME_LEN],
            :dev_name,      [:uint8, SIGAR_FS_NAME_LEN],
            :type_name,     [:uint8, SIGAR_FS_INFO_LEN],
            :sys_type_name, [:uint8, SIGAR_FS_INFO_LEN],
            :options,       [:uint8, SIGAR_FS_INFO_LEN],
            :type,          :file_system_type,
            :flags,         :ulong
          )
      end

      # typedef struct {
      #     unsigned long number;
      #     unsigned long size;
      #     sigar_file_system_t *data;
      # } sigar_file_system_list_t;
      class FSListStruct < FFI::Struct
        layout(
            :number,    :ulong,
            :size,      :ulong,
            :data,      :pointer
          )
      end
      
      # SIGAR_DECLARE(int) sigar_file_system_list_get(sigar_t *sigar, sigar_file_system_list_t *fslist);
      attach_function :sigar_file_system_list_get, [:pointer, :pointer], :int
      
      # SIGAR_DECLARE(int) sigar_file_system_list_destroy(sigar_t *sigar, sigar_file_system_list_t *fslist);
      attach_function :sigar_file_system_list_destroy, [:pointer, :pointer], :int
      
      
      # typedef struct {
      #     sigar_uint64_t reads;
      #     sigar_uint64_t writes;
      #     sigar_uint64_t write_bytes;
      #     sigar_uint64_t read_bytes;
      #     sigar_uint64_t rtime;
      #     sigar_uint64_t wtime;
      #     sigar_uint64_t qtime;
      #     sigar_uint64_t time;
      #     sigar_uint64_t snaptime;
      #     double service_time;
      #     double queue;
      # } sigar_disk_usage_t;

      # typedef struct {
      #     sigar_disk_usage_t disk;
      #     double use_percent;
      #     sigar_uint64_t total;
      #     sigar_uint64_t free;
      #     sigar_uint64_t used;
      #     sigar_uint64_t avail;
      #     sigar_uint64_t files;
      #     sigar_uint64_t free_files;
      # } sigar_file_system_usage_t;
      
      # SIGAR_DECLARE(int) sigar_file_system_usage_get(sigar_t *sigar, const char *dirname, sigar_file_system_usage_t *fsusage);
      attach_function :sigar_file_system_usage_get, [:pointer, :string, :pointer], :int
      
      # SIGAR_DECLARE(int) sigar_disk_usage_get(sigar_t *sigar, const char *name, sigar_disk_usage_t *disk);
      attach_function :sigar_disk_usage_get, [:pointer, :string, :pointer], :int

      # SIGAR_DECLARE(int) sigar_file_system_ping(sigar_t *sigar, sigar_file_system_t *fs);
      attach_function :sigar_file_system_ping, [:pointer, :pointer], :int
    end
    
    class Disk < SigarProbe
      def list()
        filesystems = Lib::FSListStruct.new
        libcall('sigar_file_system_list_get', filesystems.addr)
        # return list of available disks
        
        ret = {}
        
        arr = FFI::Pointer.new(Lib::FSStruct, filesystems[:data])
        (0..filesystems[:number]).each do |n|
          fs = Lib::FSStruct.new(arr[n].addr)
          tmp = struct_to_hash(fs,
              :string_value => [:dir_name, :dev_name, :type_name, :sys_type_name, :options],
              :identity => [:type, :flags]
            )
          
          ret[tmp['dir_name']] = tmp
        end
        
        libcall('sigar_file_system_list_destroy', filesystems.addr)
        
        ret
      end
      
      def query(root_path)
        # return info for this disk
        
        # loadavg = Lib::LoadAvgStruct.new
        # libcall('sigar_loadavg_get', loadavg.addr)
        
        # ret = struct_to_hash(loadavg,
        #     :identity => [:min1, :min5, :min15]
        #   )
        
        # ret
      end
      
    end
    
  end
end
