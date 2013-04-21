require File.expand_path('../../../spec_helper', __FILE__)

describe 'LoadAvg probe' do
  before do
    @p = HostStats::Probes::LoadAvg.new
  end
    
  should 'return global usage' do
    ret = @p.query(:default)
    ret.class.should == Hash
    
    ret['min1'].should.not == nil
    ret['min5'].should.not == nil
    ret['min15'].should.not == nil
  end
  
end
  
