# encoding: utf-8
describe P2Ruby::Router, "Driver for Router server app" do
  before(:all) { stop_router }

  it "raises error on invalid Router path" do
    expect { described_class.new :path => "blah", :ini => ROUTER_INI }.
        to raise_error /Unable to launch "blah"/
  end

  it "raises error on ini file" do
    expect { described_class.new :path => ROUTER_PATH, :ini => 'blah' }.
        to raise_error P2Ruby::Error, /Wrong ini file name/
  end

#  [QUIK_PATH, QUIK_PATH.to_s, QUIK_DIR, QUIK_DIR.to_s[0..-2]].each do |path|
#    context "initializing with args (#{path.inspect})" do
#
#      before(:all) { @quik_driver = FinDrivers::QuikDriver.new(path, logger) }
#      after(:all) { close_quik } # Reliably closes launched Quik
#
#      it 'launches Quik application' do
#        app = App.find(class
#                         : QUIK_CLASS_MAIN, timeout : 10)
#                         app.should be_an App
#                       end
#
#        it 'causes no Quik errors' do
#          Window.find(class
#                        : QUIK_CLASS_ERROR).should == nil
#                      end
#
#          specify { logger.should log_entry /Quik launched in .*tmp.Info/, :info }
#        end
#      end
#      context 'at initialization' do
#        it 'works only with pre-registered STA P2ClientGate typelib' do
#          libs = WIN32OLE_TYPELIB.typelibs
#          p2libs = libs.select { |t| t.name=~/P2ClientGate/ }
#          print 'Registered P2ClientGate libs: '
#          p p2libs.map &:guid
#          p2sta = p2libs.find { |t| t.name !~ /MTA/ }
#          p2sta.should_not be_nil
#          print 'P2ClientGate (STA) OLE types: '
#          p2sta.ole_types.map { |k| p [k.name, k.progid, k.guid] }
#        end
#
#        it 'wraps STA P2ClientGate typelib' do
#          lib = P2Ruby::Library.new
#          lib.name.should =~ /P2ClientGate/
#          lib.name.should_not =~ /MTA/
#        end
#      end # initialization
#
#      describe '.default' do
#        it 'points to (initialized) STA P2ClientGate OLE typelib singleton' do
#          P2Ruby::Library.default.should be_an_instance_of P2Ruby::Library
#        end
#      end
#
#      context 'when initialized' do
#        let(:lib) { P2Ruby::Library.default }
#
#        describe '#find' do
#          it 'returns progid needed to create OLE type with a given name' do
#            lib.find("P2Application").should == "P2ClientGate.P2Application.1"
#            lib.find("App").should == "P2ClientGate.P2Application.1"
#          end
#        end
#
#      end # when initialized with MTA type
#
end


