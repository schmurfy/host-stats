require File.expand_path('../../../spec_helper', __FILE__)

describe 'CPU probe' do
  before do
    @p = HostStats::Probes::Cpu.new
  end
  
  should 'return cpu cores count' do
    @p.list().should == %w(
        cpu.global
        cpu.0
        cpu.1
        cpu.2
        cpu.3
      )
  end
  
  should 'return global usage' do
    ret = @p.query('cpu.global')
    ret.class.should == Hash
    
    ret[:user].should.not == nil
    ret[:sys].should.not == nil
    ret[:idle].should.not == nil
    ret[:total].should >= ret[:user] + ret[:sys] + ret[:idle]
  end
  
  should 'return usage for one core' do
    ret = @p.query('cpu.1')
    ret.class.should == Hash
    
    ret[:user].should.not == nil
    ret[:sys].should.not == nil
    ret[:idle].should.not == nil
    ret[:total].should >= ret[:user] + ret[:sys] + ret[:idle]
  end

end
  
