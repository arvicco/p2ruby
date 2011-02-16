require 'spec_helper'

describe P2Ruby::Connection do
  subject { P2Ruby::Connection.new }

  it 'wraps P2ClientGate.P2Connection OLE class' do
    subject.ole_type.name.should == 'IP2Connection'
    print 'Implemented OLE types: '; p subject.ole_type.implemented_ole_types
    print 'Source OLE types: '; p subject.ole_type.source_ole_types
    print 'OLE methods: '
    p subject.ole_methods.map{|m| "#{m.invoke_kind} #{m.name}(#{m.params.join ', '})"}
  end

  its(:AppName){should =~ /APP-./}  # •	1 — Plaza; •	2 — Plaza-II (default)

end
