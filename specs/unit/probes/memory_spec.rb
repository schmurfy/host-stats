require File.expand_path('../../../spec_helper', __FILE__)

describe 'Memory probe' do
  before do
    @p = HostStats::Probes::Memory.new
  end
    
  should 'return global usage' do
    ret = @p.query(:default)
    ret.class.should == Hash
    
    ret['ram'].should.not == nil
    ret['total'].should.not == nil
    ret['used'].should.not == nil
    ret['actual_used'].should.not == nil
    ret['actual_free'].should.not == nil
    
    
    (ret['actual_free'] + ret['actual_used']).should == ret['total']
    (ret['used_percent'] + ret['free_percent']).should == 100
  end
  
end
  
