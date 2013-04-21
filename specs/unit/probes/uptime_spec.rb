require File.expand_path('../../../spec_helper', __FILE__)

describe 'Uptime probe' do
  before do
    @p = HostStats::Probes::Uptime.new
  end
    
  should 'return global usage' do
    ret = @p.query(:default)
    ret.class.should == Hash
    
    ret['uptime'].should.not == nil
  end
  
end
  
