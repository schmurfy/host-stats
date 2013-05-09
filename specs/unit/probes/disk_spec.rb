require File.expand_path('../../../spec_helper', __FILE__)

describe 'Disk probe' do
  before do
    @p = HostStats::Probes::Disk.new
  end
  
  should 'know maxpathlen' do
    HostStats.maxpathlen.should != 0
  end
  
  should 'return disks list' do
    ret = @p.list()
    
    ret.size.should > 0
    ret['/'].tap do |f|
      f.class.should == Hash
      f['dir_name'].should == '/'
      f['type'].should == :local
    end
  end
    
  # should 'return global usage' do
  #   ret = @p.query(:default)
  #   ret.class.should == Hash
    
  #   ret['ram'].should.not == nil
  #   ret['total'].should.not == nil
  #   ret['used'].should.not == nil
  #   ret['actual_used'].should.not == nil
  #   ret['actual_free'].should.not == nil
    
    
  #   (ret['actual_free'] + ret['actual_used']).should == ret['total']
  #   (ret['used_percent'] + ret['free_percent']).should == 100
  # end
  
end
  
