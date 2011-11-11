# encoding: CP1251
require 'spec_helper'

describe P2::Library do

  context 'at initialization' do
    it 'works only with pre-registered STA P2ClientGate typelib' do
      libs = WIN32OLE_TYPELIB.typelibs
      p2libs = libs.select { |t| t.name=~/P2ClientGate/ }
      print 'Registered P2ClientGate libs: '
      p p2libs.map &:guid
      p2sta = p2libs.find { |t| t.name !~ /MTA/ }
      p2sta.should_not be_nil
      print 'P2ClientGate (STA) OLE types: '
      p2sta.ole_types.map { |k| p [k.name, k.progid, k.guid, k.implemented_ole_types] }
    end

    it 'wraps STA P2ClientGate typelib' do
      lib = P2::Library.new
      lib.name.should =~ /P2ClientGate/
      lib.name.should_not =~ /MTA/
    end
  end # initialization

  describe '.default' do
    it 'points to (initialized) STA P2ClientGate OLE typelib singleton' do
      P2::Library.default.should be_an_instance_of P2::Library
    end
  end

  context 'when initialized' do
    let(:lib) { P2::Library.default }

    describe '#find' do
      it 'returns progid needed to create OLE type with a given name' do
        lib.find("P2Application").should == "P2ClientGate.P2Application.1"
        lib.find("App").should == "P2ClientGate.P2Application.1"
      end
    end

  end # when initialized
end
