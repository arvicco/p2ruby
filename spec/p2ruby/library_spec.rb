require 'spec_helper'

describe P2Ruby::Library do

  context 'at initialization' do
    it 'works only if P2ClientGate(MTA) OLE typelib is pre-registered' do
      libs = WIN32OLE_TYPELIB.typelibs
      p2libs = libs.select { |t| t.name=~/P2ClientGate/ }
      p p2libs.map &:guid
      p2mta = p2libs.find { |t| t.name=~/MTA/ }
      p2mta.should_not be_nil
      p p2mta.ole_types.collect { |k| k.name }
    end

    it 'wraps P2ClientGateMTA typelib by default' do
      lib = P2Ruby::Library.new
      lib.name =~ /P2ClientGateMTA/
    end

    it 'wraps P2ClientGateMTA typelib given :mta type' do
      lib = P2Ruby::Library.new :mta
      lib.name =~ /P2ClientGateMTA/
    end

    it 'wraps P2ClientGate typelib given :sta type' do
      lib = P2Ruby::Library.new :sta
      lib.name =~ /P2ClientGateMTA/
    end
  end # initialization

  describe '.default' do
    it 'points to (initialized) P2ClientGate(MTA) OLE typelib singleton' do
      P2Ruby::Library.default.should be_an_instance_of P2Ruby::Library
    end
  end

  context 'when initialized with MTA type' do
    let(:lib) {P2Ruby::Library.default}

    describe '#build' do
      it 'builds P2ClientGate(MTA) OLE type with given name and init args' do
        app = lib.build "P2Application"
        app.should be_an_instance_of WIN32OLE
        p (app.methods - Object.methods).sort
      end
    end

  end # when initialized with MTA type
end
