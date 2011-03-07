# encoding: utf-8
require 'spec_helper'

# TableSet received from RTS as part of DataStream opening event?
def get_table_set
  P2::Application.reset CLIENT_INI
  @conn = P2::Connection.new :app_name => 'RecordTest',
                             :host => "127.0.0.1", :port => 4001
  @conn.Connect

  @ds = P2::DataStream.new :stream_name => 'RTS_INDEX_REPL',
                           :type => P2::RT_COMBINED_DYNAMIC

  @ds.Open(@conn)

  @ds.events.on_event { |*args| p args }
  2.times { @conn.ProcessMessage2(1000) } # Push @ds to receive its TableSet
end

describe P2::TableSet do
  before(:all) do
    start_router
    get_table_set
  end

  after(:all) do
    @ds.Close() if @ds.open?
    @conn.Disconnect() if @conn.connected?
    stop_router
  end

  describe '.new' do
    context 'with directly instantiated TableSet' do
      subject { P2::TableSet.new :ini => TABLESET_INI, :life_num => 1313, :rev => {'rts_index'=>13} }

      it 'wraps OLE class with IP2TableSet interface' do
        subject.ole_type.name.should == 'IP2TableSet'
        show_ole
      end

      its(:clsid) { should == '{C52E4892-894B-4C03-841F-97E893F7BCAE}' }
      its(:progid) { should == 'P2ClientGate.P2TableSet.1' }
      its(:opts) { should be_a Hash }
      its(:ole) { should be_a WIN32OLE }
      its(:Count) { should == 1 } # One table!
      its(:LifeNum) { should == 1313 }

      it 'should be possible to access named properties' do
        subject.FieldList['rts_index'].should == "replID,replRev,replAct,name,moment,value,prev_close_value,open_value,max_value,min_value,usd_rate,cap,volume"
        subject.FieldTypes['rts_index'].should == "replID=i8,replRev=i8,replAct=i8,name=c25,moment=t,value=d18.4,prev_close_value=d18.4,open_value=d18.4,max_value=d18.4,min_value=d18.4,usd_rate=d10.4,cap=d18.4,volume=d18.4"
        subject.Rev['rts_index'].should == 13
        subject.rev['rts_index'].should == 13
      end

      it 'should be possible to reset settable properties' do
        subject.LifeNum = 1
        subject.Rev['rts_index'] = 1

        subject.LifeNum.should == 1
        subject.Rev['rts_index'].should == 1
      end

    end

    context 'with TableSet received from RTS' do
      subject { P2::TableSet.new :ole => @ds.ole.TableSet }
      describe '#each' do

        it 'is' do
          p subject
          p subject.Count()
          p (subject.each.methods-Object.methods).sort
          p subject.each { |item| p item }
          p enum = subject.ole_methods.find { |m| m.name=~ /Enum/ }
          (enum.methods-Object.methods).each do |m|
            puts "#{m}: #{(enum.send(m)).inspect}"
          end
          puts 'Returned by .NewEnum(), ._NewEnum() and .invoke "_NewEnum" :'
          p subject.NewEnum()
          p subject._NewEnum()
          p subject.invoke "_NewEnum"
          p "WIN32OLE::ARGV"
          p WIN32OLE::ARGV
          p subject.each.to_a.size

        end
      end

    end
  end

  describe '#InitFromIni'
  describe '#InitFromIni2'

  describe '#InitFromDB'
  describe '#SetLifeNumToIni'
  describe '#AddTable'
  describe '#DeleteTable'

#  describe '#to_s' do
#    it 'reveals fields content' do
#      p subject.to_s
#      p subject.to_s.encoding
#      subject.to_s.should =~ /\d+|\d|\d|.+RTS/
#      subject.to_s.scan(/\|/).size.should == 12
#    end
#  end
#
#  describe '#[]' do
#    it 'provides access to field content by field name' do
#      subject['name'].should =~ /RTS/
#      subject['moment'].should =~ Regexp.new(Time.now.strftime("%Y/%m/"))
#    end
#
#    it 'provides access to field content by field index' do
#      subject[3].should =~ /RTS/
#      subject[4].should =~ Regexp.new(Time.now.strftime("%Y/%m/"))
#    end
#  end
#
#  describe '#each' do
#    it 'enumerates all fields' do
#      subject.each.size.should == 13
#    end
#
#    it 'serves as a basis for mixed in Enumerable methods' do
#      subject.select { |f| f =~ /RTS/ }.should_not == nil
#      subject.any? { |f| f =~ /RTS/ }.should == true
#    end
#  end
end

