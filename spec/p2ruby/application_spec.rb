require 'spec_helper'

describe P2Ruby::Application do
  subject { P2Ruby::Application.new INI_PATH }

  it 'wraps P2ClientGate.P2Application OLE class' do
    subject.ole_type.name.should == 'IP2Application'
    print 'Implemented OLE types: '; p subject.ole_type.implemented_ole_types
    print 'Source OLE types: '; p subject.ole_type.source_ole_types
    print 'OLE methods:' ; p (subject.ole_methods - Object.methods).map &:name
  end
end
