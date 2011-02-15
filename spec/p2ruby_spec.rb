require 'spec_helper'

describe P2Ruby do

  it 'works only if P2ClientGate OLE typelib is pre-registered' do
    p2lib = WIN32OLE_TYPELIB.typelibs.find{|t| t.name=~/P2ClientGate/}
    p2lib.should_not be_nil
    p p2lib.ole_types.collect{|k| k.name}
  end
end

