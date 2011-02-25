# encoding: utf-8
require 'spec_helper'

# Impossible to instantiate Record directly (no PROGID), need to receive
# it from RTS as part of DataStream event
def get_record
  @record = nil
  P2::Application.reset CLIENT_INI
  @conn = P2::Connection.new :app_name => 'RecordTest',
                             :host => "127.0.0.1", :port => 4001
  @conn.Connect

  @ds = P2::DataStream.new :stream_name => 'RTS_INDEX_REPL',
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

  describe '#to_s' do
    it 'reveals fields content' do
      p subject.to_s
      subject.to_s.should =~ /\d+|\d|\d|.+RTS/
      subject.to_s.scan(/\|/).size.should == 12
    end
  end

  describe '#[]' do
    it 'provides access to field content by field name' do
      subject['name'].should =~ /RTS/
      subject['moment'].should =~ Regexp.new(Time.now.strftime("%Y/%m/%d"))
    end

    it 'provides access to field content by field index' do
      subject[3].should =~ /RTS/
      subject[4].should =~ Regexp.new(Time.now.strftime("%Y/%m/%d"))
    end
  end

  describe '#each' do
    it 'enumerates all fields' do
      subject.each.size.should == 13
    end

    it 'serves as a basis for mixed in Enumerable methods' do
      subject.select { |f| f =~ /RTS/ }.should_not == nil
      subject.any? { |f| f =~ /RTS/ }.should == true
    end
  end
end

