# encoding: utf-8
require 'spec_helper'

def random_name
  "APP-#{rand 10000}"
end

shared_examples_for 'new connection' do

  its(:clsid) { should == '{CCD42082-33E0-49EA-AED3-9FE39978EB56}' }
  its(:progid) { should == 'P2ClientGate.P2Connection.1' }
  its(:opts) { should be_a Hash }
  its(:ole) { should be_a WIN32OLE }
  its(:Status) { should == P2::CS_CONNECTION_DISCONNECTED }
  its(:status_text) { should == 'Connection Disconnected' }

  it 'raises on NodeName access' do
    expect { subject.NodeName }.to raise_error /Couldn't get MQ node name/
#      its(:NodeName) { should == "??" }
  end

  it 'is possible to set settable properties' do
    # Notes: —войства AppName, NodeName, Host, Port, Password и Timeout должны быть
    # заданы до момента вызова метода Connect. ¬ случае изменени€ данных свойств дл€
    # того, чтобы изменени€ вступили в силу необходимо провести последовательный вызов
    # методов Disconnect и Connect. ѕараметры аутентификации роутера (LoginStr) должны
    # быть заданы до момента вызова метода Login.
    subject.AppName ='REASSIGNED'
    subject.Host ='REASSIGNED_HOST'
    subject.Port =1313
    subject.LoginStr ='REASSIGNED_STRING'
    subject.Timeout =13
    subject.Password ='REASSIGNED_PASS'

    subject.AppName.should == 'REASSIGNED'
    subject.Name.should == 'REASSIGNED'
    subject.name.should == 'REASSIGNED'
    subject.Host.should == 'REASSIGNED_HOST'
    subject.Port.should == 1313
    subject.LoginStr.should =='REASSIGNED_STRING'
    subject.Timeout.should == 13
    #    subject.Password.should == 'REASSIGNED_PASS' # - No accessor for Password!
  end

  it 'is possible to set/access AppName property through aliases' do
    subject.Name ='Set through Name'
    subject.AppName.should == 'Set through Name'
    subject.Name.should == 'Set through Name'
    subject.name.should == 'Set through Name'

    subject.name ='Now set through name'
    subject.AppName.should == 'Now set through name'
    subject.Name.should == 'Now set through name'
    subject.name.should == 'Now set through name'
  end

  it 'is not connected right away' do
    subject.should_not be_connected
  end
end

describe P2Ruby::Connection do
  before(:all) do
    start_router
    P2Ruby::Application.reset CLIENT_INI
  end
  after(:all) { stop_router }

  describe '.new' do
    context 'with options' do
      subject { P2Ruby::Connection.new :ini => CLIENT_INI,
                                       :app_name => random_name,
                                       :host => "localhost",
                                       :port => 3333,
                                       :timeout => 500,
                                       :login_str => "Blah" }

      it 'wraps P2ClientGate.P2Connection OLE class' do
        subject.ole_type.name.should == 'IP2Connection'
        show_ole
      end

      its(:AppName) { should =~ /APP-./ }
      its(:Host) { should == "localhost" }
      its(:Port) { should == 3333 }
      its(:Timeout) { should == 500 }
      its(:LoginStr) { should == "Blah" }

      # Alias properties
      its(:Name) { should =~ /APP-./ }
      its(:name) { should =~ /APP-./ }

      it_behaves_like 'new connection'
    end

    context 'by default' do
      # Ini file is still necessary if Application instance does not exist yet. Otherwise
      # Connection#new will SEGFAULT looking for default "P2ClientGate.ini" in current dir
      subject { P2Ruby::Connection.new }

      its(:AppName) { should == '' }
      its(:Host) { should == '' }
      its(:Port) { should == 3000 }
      its(:Timeout) { should == 1000 }
      its(:LoginStr) { should == '' }
      it_behaves_like 'new connection'
    end
  end

  describe '#Connect()', 'creates local connection to Router' do
    context 'with correct connection parameters' do
      it 'connects successfully' do
        @conn = P2Ruby::Connection.new :app_name => random_name,
                                       :host => "127.0.0.1", :port => 4001
        @conn.Connect().should == P2::P2ERR_OK
        @conn.NodeName.should == ROUTER_LOGIN
        @conn.should be_connected
        @conn.status_text.should == "Connection Connected, Router Connected"
      end
    end

    context 'with wrong connection parameters' do
      it 'fails to connect' do
        @conn = P2Ruby::Connection.new :app_name => random_name, :timeout => 200,
                                       :host => "127.0.0.1", :port => 1313
        expect { @conn.Connect() }.to raise_error /Couldn't connect to MQ/
        @conn.should_not be_connected
        @conn.status_text.should == "Connection Disconnected"
      end
    end
  end

  describe '#Disconnect()', 'drops local connection to Router' do
    context 'when connected to Router' do
      before do
        @conn = P2Ruby::Connection.new :app_name => random_name,
                                       :host => "127.0.0.1", :port => 4001
        @conn.Connect()
        @conn.should be_connected
      end

      it 'disconnects from Router successfully' do
        @conn.Disconnect()
        expect { @conn.NodeName }.to raise_error /Couldn't get MQ node name/
        @conn.should_not be_connected
        @conn.status_text.should == "Connection Disconnected"
      end
    end

    context 'when NOT connected to Router' do
      it 'it`s noop' do
        @conn = P2Ruby::Connection.new :app_name => random_name,
                                       :host => "127.0.0.1", :port => 1313
        @conn.Disconnect()
        @conn.should_not be_connected
      end
    end
  end

  describe '#Connect2 '
  #  Connect2 ( [in] BSTR connStr, [out, retval] ULONG* errClass);
  #  —оздание локального соединени€ приложени€ с роутером. ƒополнение к методу Connect.

  describe '#ProcessMessage'
  #  ProcessMessage ( [out] ULONG* cookie,  [in] ULONG pollTimeout);
  #  ѕрием и обработка сообщений, в том числе и репликационных.
  #  јргументы
  #  Х	pollTimeout Ч таймаут в миллисекундах, в течение которого ожидаетс€ получение сообщени€;
  #  Х	cookie Ч уникальный идентификатор подписчика.

  describe '#ProcessMessage2'
  #  ProcessMessage2 ( [in] ULONG pollTimeout, [out, retval] ULONG* cookie);
  #  ѕрием и обработка сообщений. ¬ыпущен в дополнение к методу Connection.ProcessMessage,
  #  так как тот не позвол€л в интерпретированных €зыках (JScript) получить результат
  #  работы функции (cookie).

  describe '#RegisterReceiver'
  #  RegisterReceiver ( [in] IP2MessageReceiver* newReceiver, [out,retval] ULONG* cookie);
  #  –егистраци€ подписчика.
  #  јргументы
  #  Х	newReceiver Ч указатель на интерфейс обратного вызова;
  #  Х	cookie Ч уникальный идентификатор подписчика. »спользуетс€ дл€ того, чтобы можно
  #     было отменить подписку, а также именно по нему в методе Connection.ProcessMessage
  #     определ€етс€ получатель сообщени€.

  describe '#UnRegisterReceiver'
  #  UnRegisterReceiver ([in] ULONG cookie);
  #  ќтмена регистрации подписчика.

  describe '#ResolveService' do
    #  ResolveService ( [in] BSTR service, [out,retval] BSTR* address);
    #  ѕолучение полного адреса приложени€ по имени сервиса, который оно предоставл€ет.
    #  јргументы
    #  Х	service Ч им€ сервиса;
    #  Х	address Ч полный адрес приложени€.

    before(:all) do
      @conn = P2Ruby::Connection.new :app_name => random_name,
                                     :host => "127.0.0.1", :port => 4001
      @conn.Connect()
      @conn.should be_connected
      @conn.should be_logged
    end

    it 'returns full server address, given a service name' do
      @conn.ResolveService('FORTS_OPTINFO_REPL').should == "FINTER_FORTS3.inter_info"
      @conn.ResolveService('FORTS_FUTINFO_REPL').should == "FINTER_FORTS3.inter_info"
      @conn.ResolveService('FORTS_POS_REPL').should == "FINTER_FORTS3.inter_pos"
      @conn.ResolveService('FORTS_FUTCOMMON_REPL').should== "FINTER_FORTS3.inter_futcommon"
      @conn.ResolveService('FORTS_OPTCOMMON_REPL').should== "FINTER_FORTS3.inter_optcommon"
      @conn.ResolveService('FORTS_VOLAT_REPL').should == "FINTER_FORTS3.inter_vmv"
      @conn.ResolveService('FORTS_VM_REPL').should == "FINTER_FORTS3.inter_vmv"
      # Order placement:
      @conn.ResolveService("FORTS_SRV").should == "FINTER_FORTS3.Dispatcher"
    end
  end

  #	јутентификаци€ выполн€етс€ асинхронно. ”спешный возврат из метода Login означает,
  # что аутентификационна€ информаци€ была послана на сервер. ƒл€ того, чтобы узнать,
  # успешно ли завершилась аутентификаци€, следует получать и обрабатывать уведомлени€
  # о состо€нии соединени€.
  context 'When router is authenticated via ini file' do
  end
  context 'When router is authenticated explicitely - via Login()' do
  end

  describe '#Logout(void)', 'drops Router connection to uplink (RTS)' do
    context 'when Router is connected' do
      before(:all) do
        @conn = P2Ruby::Connection.new :app_name => random_name,
                                       :host => "127.0.0.1", :port => 4001
        @conn.Connect()
        @conn.should be_connected
        @conn.Logout()
      end

      it 'keeps local connection to Router' do
        @conn.should be_connected
      end

      it 'only sends an ASYNC request to disconnect Router from uplink' do
        @conn.should be_logged # Need to wait for Server to react to logout
      end
    end
  end #Logout()

  describe '#events' do
    before(:each) do
      @conn = P2Ruby::Connection.new :app_name => random_name,
                                     :host => "127.0.0.1", :port => 4001
      @conn.Connect()
      @events = @conn.events
      @event_fired = false
    end

    it 'provides access to (IP2ConnectionEvent interface) events' do
      @events.should be_kind_of WIN32OLE_EVENT
    end

    it 'allows setting callbacks for IP2ConnectionEvent interface events' do
      @events.on_event do |event_name, ole, status|
        @event_fired = true
        p "EVENT: #{event_name}, #{ole}, #{status}"
        event_name.should == "ConnectionStatusChanged"
        ole.ole_type.name.should == "IP2Connection"
        status.should be_kind_of Fixnum
      end

      @conn.ProcessMessage2(100) # Grabs messages/events from queue
      @event_fired.should == true
    end

    it 'allows setting explicit handler for IP2ConnectionEvent events' do
      class TestHandler
        attr_accessor :event_fired

        def onConnectionStatusChanged(ole, status)
          puts "StatusTextChanged"
          @event_fired = true
          p "HANDLER EVENT (ConnectionStatusChanged): #{ole}, #{status}"
          ole.ole_type.name.should == "IP2Connection"
          status.is_a?(Fixnum).should == true # We are inside Handler class, no #be_kind_of
        end
      end

      @events.handler = TestHandler.new
      @conn.ProcessMessage2(100) # Grabs messages/events from queue

      @events.handler.should be_a TestHandler
      @events.handler.event_fired.should == true
    end
  end #events
end
