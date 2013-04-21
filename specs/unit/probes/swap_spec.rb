require File.expand_path('../../../spec_helper', __FILE__)

describe 'Swap probe' do
  before do
    @p = HostStats::Probes::Swap.new
  end
    
  should 'return global usage' do
    ret = @p.query(:default)
    ret.class.should == Hash
    
    ret['total'].should.not == nil
    ret['used'].should.not == nil
    ret['free'].should.not == nil
    ret['page_in'].should.not == nil
    ret['page_out'].should.not == nil
    
    (ret['used'] + ret['free']).should == ret['total']
    (ret['used_percent'] + ret['free_percent']).should == 100
  end
  
end
  
