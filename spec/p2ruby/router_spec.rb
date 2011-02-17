# encoding: utf-8
describe P2Ruby::Router, "Driver for Router server app" do
  before(:all) { stop_router }
  after(:each) { stop_router }

  it "raises error on invalid Router path" do
    expect { described_class.new :path => "blah", :ini => ROUTER_INI }.
        to raise_error /Unable to launch "blah"/
  end

  it "raises error on invalid ini file" do
    expect { described_class.new :path => ROUTER_PATH, :ini => 'blah' }.
        to raise_error P2Ruby::Error, /Wrong ini file name/
  end

  context "initializing with :path => #{ROUTER_PATH}, :ini => #{ROUTER_INI}" do

    before(:all) { @router = P2Ruby::Router.new :dir => TEST_DIR, # To avoid file litter in BASE_DIR
                                                :path => ROUTER_PATH, :ini => ROUTER_INI }

    it 'launches P2 Router application' do
      app = WinGui::App.find(:title => ROUTER_TITLE)
      app.should be_an WinGui::App
    end
  end
end


