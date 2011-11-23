# encoding: CP1251
require 'spec_helper'
require 'benchmark'

# Impossible to instantiate Record directly (no PROGID), need to receive
# it from RTS as part of DataStream event
def get_record
  @record = nil
  P2::Application.reset CLIENT_INI
  @conn = P2::Connection.new :app_name => 'RecordTest',
                             :host => "127.0.0.1", :port => 4001
  @conn.Connect
  sleep 0.5

  @ds = P2::DataStream.new :stream_name => 'RTS_INDEX_REPL', # 'FORTS_FUTTRADE_REPL',
                           :type => P2::RT_COMBINED_DYNAMIC

  @ds.events.on_event('StreamDataInserted') do |event_name, table, ole|
    p "EVENT: #{event_name}, #{table}, #{ole}"
    @record = ole
  end

  @ds.Open(@conn)
  @conn.ProcessMessage2(1000) until @record
  @record
end

describe P2::Record do
  before(:all) do
    start_router
    get_record
  end

  after(:all) do
    @ds.Close()
    @conn.Disconnect()
    stop_router
  end

  subject { P2::Record.new :ole => @record }

  describe '.new' do
    it 'wraps OLE class with IP2Record interface' do
      subject.ole_type.name.should == 'IP2Record'
      show_ole
    end

    its(:clsid) { should == '{76033FC9-8BB0-4415-A785-9BF86AAF4E99}' }
    its(:progid) { should == nil } # Impossible to instantiate directly!
    its(:opts) { should be_a Hash }
    its(:ole) { should be_a WIN32OLE }
    its(:Count) { should == 13 }
  end

  describe 'OLE field accessors' do
    describe 'accessing Datetime fields' do
      it 'is unable to access Datetime field in Integer format :(' do
        expect { subject.GetValAsLong('moment') }.to raise_error WIN32OLERuntimeError
        expect { subject.GetValAsLongByIndex(4) }.to raise_error WIN32OLERuntimeError
      end

      it 'accesses Datetime field as Variant' do
        #p subject.each
        # "2009/12/01 12:35:44.785" => 20091201123544785
        moment = subject.GetValAsVariant('moment')
        moment.should be_an Integer
        moment.should be > 20100101003030000
        moment = subject.GetValAsVariantByIndex(4)
        moment.should be_an Integer
        moment.should be > 20100101003030000
      end

      it 'Variant access is fast enough' do
        n = 100_000
        rec = subject
        Benchmark.bmbm(14) do |x|
          x.report("String by name:  ") { n.times { a = rec.GetValAsString('moment') } }
          x.report("String by index: ") { n.times { a = rec.GetValAsStringByIndex(4) } }
          x.report("Variant by name: ") { n.times { a = rec.GetValAsVariant('moment') } }
          x.report("Variant by index:") { n.times { a = rec.GetValAsVariantByIndex(4) } }
        end
      end
    end

    describe 'accessing Decimal fields' do
      it 'returns String when accessing Decimal field as Variant' do
        value = subject.GetValAsVariant('value')
        value.should be_a String
        value = subject.GetValAsVariantByIndex(5)
        value.should be_an String
      end

      it 'Variant access is fast enough' do
        n = 100_000
        rec = subject
        Benchmark.bmbm(14) do |x|
          x.report("String by name:  ") { n.times { a = rec.GetValAsString('value').to_f } }
          x.report("String by index: ") { n.times { a = rec.GetValAsStringByIndex(5).to_f } }
          x.report("Variant by name: ") { n.times { a = rec.GetValAsVariant('value').to_f } }
          x.report("Variant by index:") { n.times { a = rec.GetValAsVariantByIndex(5).to_f } }
        end
      end
    end

    describe 'accessing Int64 (:i8) fields' do
      it 'accesses Int64 (:i8) field as Variant' do
        repl = subject.GetValAsVariant('replRev')
        repl.should be_an Integer
        repl = subject.GetValAsVariantByIndex(1)
        repl.should be_an Integer
      end

      it 'Variant access is fast enough' do
        n = 100_000
        rec = subject
        Benchmark.bmbm(14) do |x|
          x.report("String by name:  ") { n.times { a = rec.GetValAsString('replRev').to_i } }
          x.report("String by index: ") { n.times { a = rec.GetValAsStringByIndex(1).to_i } }
          x.report("Variant by name: ") { n.times { a = rec.GetValAsVariant('replRev') } }
          x.report("Variant by index:") { n.times { a = rec.GetValAsVariantByIndex(1) } }
        end
      end
    end
  end

  describe '#to_s' do
    it 'reveals fields content' do
      p subject.to_s
      p subject.to_s.encoding
      subject.to_s.should =~ /\d+\|\d+\|\d\|RTS|MICEX/
      subject.to_s.scan(/\|/).size.should == 12
    end
  end

  describe '#[]' do
    it 'provides access to field content by field name' do
      subject['name'].should =~ /RTS|MICEX/
      subject['moment'].should =~ Regexp.new(Time.now.strftime("%Y/%m/"))
    end

    it 'provides access to field content by field index' do
      subject[3].should =~ /RTS|MICEX/
      subject[4].should =~ Regexp.new(Time.now.strftime("%Y/%m/"))
    end

    it 'retrieves field content in most universal (String) format' do
      subject['name'].should be_a String
      subject['value'].should be_a String
      subject['replID'].should be_a String
    end

  end

  describe '#each' do
    it 'enumerates all fields' do
      subject.each.size.should == 13
    end

    it 'serves as a basis for mixed in Enumerable methods' do
      subject.select { |f| f =~ /RTS|MICEX/ }.should_not == nil
      subject.any? { |f| f =~ /RTS|MICEX/ }.should == true
    end
  end
end

