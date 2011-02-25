# encoding: utf-8
require 'spec_helper'

describe P2Ruby::Router, "Driver for Router server app" do
  before(:all) { stop_router }
  after(:all) { stop_router }

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

  context "router initialized with :path => #{ROUTER_PATH}, :ini => #{ROUTER_INI}" do
    before(:all) { @router = P2Ruby::Router.new :dir => TEST_DIR, # To avoid file litter in BASE_DIR
                                                :path => ROUTER_PATH, :ini => ROUTER_INI }
    subject { @router }

    it 'has P2 Router application/window launched' do
      app = WinGui::App.find(:title => ROUTER_TITLE)
      app.should be_an WinGui::App
    end

    it 'is possible to find already launched Router' do
      router = P2Ruby::Router.find
      router.should be_a P2Ruby::Router
    end

    its(:opts) { should have_key :path }
    its(:app) { should be_a WinGui::App }
    its(:main_window) { should be_a WinGui::Window }
    its(:title) { should =~ ROUTER_TITLE }

    context 'forcing Router app to quit' do
      it 'exits gracefully when asked to' do
        @router.exit
        sleep 0.6 # needed to ensure Router window had enough time to close down
        @router.main_window.visible?.should == false
        @router.main_window.window?.should == false
      end
    end
  end
end


