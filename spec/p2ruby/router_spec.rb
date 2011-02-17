# encoding: utf-8
describe P2Ruby::Router, "Driver for Router server app" do
  before(:all) { stop_router }

  it "raises error on invalid Router path" do
    expect { described_class.new :path => "blah", :ini => ROUTER_INI }.
        to raise_error /Unable to launch "blah"/
  end

  it "raises error on invalid ini file" do
    expect { described_class.new :path => ROUTER_PATH, :ini => 'blah' }.
        to raise_error P2Ruby::Error, /Wrong ini file name/
  end

  it 'is impossible to find unlaunched Router' do
    @app = P2Ruby::Router.find
    @app.should be_nil
  end

  context "initialized with :path => #{ROUTER_PATH}, :ini => #{ROUTER_INI}" do
    after(:all) { stop_router }
    before(:all) { @router = P2Ruby::Router.new :dir => TEST_DIR, # To avoid file litter in BASE_DIR
                                                :path => ROUTER_PATH, :ini => ROUTER_INI }
    it 'has P2 Router application/window launched' do
      app = WinGui::App.find(:title => ROUTER_TITLE)
      app.should be_an WinGui::App
    end

    it 'is possible to find already launched Router' do
      router = P2Ruby::Router.find
      router.should be_a P2Ruby::Router
    end

#        it 'main_window' do
#          @app.main_window.should be_a Window
#          @app.main_window.title.should == WIN_TITLE
#        end
#      end
#    end
#
#    context 'manipulating' do
#      before(:each) { @app = App.launch(path: APP_PATH, title: WIN_TITLE) }
#
#      it 'exits App gracefully' do
#        @app.exit
#        sleep SLEEP_DELAY # needed to ensure window had enough time to close down
#        @app.main_window.visible?.should == false
#        @app.main_window.window?.should == false
#      end
#
#      it 'closes App gracefully' do
#        @app.close
#        sleep SLEEP_DELAY # needed to ensure window had enough time to close down
#        @app.main_window.visible?.should == false
#        @app.main_window.window?.should == false
#      end
#    end
  end
end


