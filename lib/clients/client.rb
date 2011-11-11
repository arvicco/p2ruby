require 'pp'
require 'win/time'
require 'clients/exception_wrapper'

# TODO: Change Client into an Interface module, force concrete classes to include it?
# Base (non-configureble!)client class, all configuration in-code, subclass it for your specific needs
module Clients

  # Base (non-configureble!)client class, all configuration in-code, subclass it for your specific needs
  class Client
    # File path constants
    # TODO: Set paths in calling script, instead of hardcoding here?
    LOG_PATH = LOG_DIR + 'basic_client.log'
    REV_PATH = DATA_DIR + 'BasicRevisions.txt'
    APP_NAME = 'Client'

    include Mix::ExceptionWrapper

    attr_accessor :name, :conn, :logger, :streams, :outputs, :stopped

    # Uniform access to table handlers via @client[:instruments] syntax
    def [] key
      send key
    end

    def initialize opts = {}
      @name = opts[:name] || APP_NAME
      @logger = opts[:logger] || STDOUT # File.new(LOG_PATH, "w") # System.Text.Encoding.Unicode)
      @stop = false

      begin
        # Create Connection object with P2MQRouter connectivity parameters
        @conn = P2::Connection.new :ini => CLIENT_INI,
                                   :host => "localhost",
                                   :port => 4001,
                                   :AppName => @name
        # Client will handle Connection's events by default
        @conn.events.handler = self

        @streams = {}
        @outputs = []
        # Run setup for client subclasses
        setup opts

        # Adding streams stats to outputs:
        @outputs += @streams.map { |id, stream| [id, stream.stats] }.flatten

      rescue WIN32OLERuntimeError => e
        puts e
        if P2.p2_error(e) == P2::P2ERR_INI_FILE_NOT_FOUND #Marshal.GetHRForException(e)
          puts "Can't find one or both of ini file: P2ClientGate.ini, orders_aggr.ini"
        end
        raise e
      rescue Exception => e #(System.Exception e)
        puts "Raising non-Win32Ole error in initialize: #{e}"
        raise e
      end
    end

    # Override and set up @streams and @outputs here
    # (as well as other artifacts specific to your client)
    def setup opts = {}
    end

    # Main event cycle
    def run
      until @stop
        try do
          # (Re)-connecting to Router
          @conn.Connect()

          # Processing messages in a loop
          try { process_messages until @stop }

          # Make sure streams are closed and disconnect before reconnecting
          disconnect
        end
      end
      finalize
    end

    # Keep alive streams and process messages once
    def process_messages
      # Check status for all streams, reopen as necessary
      @streams.each { |_, stream| try { stream.keep_alive } }

      # Actual processing of incoming messages happens in event callbacks
      # Oбрабатываем пришедшее сообщение в интерфейсах обратного вызова
      @conn.ProcessMessage2(100)
    end

    # First close streams, then disconnect connection
    def disconnect
      @streams.each { |_, stream| try { stream.finalize } }
      @conn.Disconnect()
    end

    # Client's cleanup actions
    def finalize
      # Make sure this finalizer runs only once
      unless @stopping
        @stop = true
        @stopping = true
        disconnect

        @outputs.each { |out| pp out }
        @stopped = true
      end
    end

    # Handling Connection status change
    def onConnectionStatusChanged(conn, new_status)
      puts :info, "MQ connection state " + @conn.status_text(new_status)

      if ((new_status & P2::CS_ROUTER_CONNECTED) != 0)
        # Когда соединились - запрашиваем адрес сервера-обработчика ?
      end
    end
  end # class Client
end # module Clients
