# encoding: CP1251
require_relative 'script_helper'
require_relative 'vcl_orderbook'

STREAM_INFO_NAME = 'FORTS_FUTINFO_REPL'
STREAM_AGGR_NAME = 'FORTS_FUTAGGR50_REPL'

TABLE_AGGR_NAME = 'orders_aggr'
TABLE_FUTSESS_NAME = 'fut_sess_contents'

module VCL


#  // ������� ����� ����������
#  type
#    Client = class(TForm)   # TForm1
#      LogListBox: TListBox;
#      ConnectButton: TButton;
#      DisconnectButton: TButton;
#      InstrumentComboBox: TComboBox;
#      OrderBookGrid: TStringGrid;
#      procedure FormCreate(Sender: TObject);
#      procedure ConnectButtonClick(Sender: TObject);
#      procedure DisconnectButtonClick(Sender: TObject);
#      procedure InstrumentComboBoxChange(Sender: TObject);
#    private
#      fPreciseTime: TPreciseTime;
#      fApp: TCP2Application;
#      fConn: TCP2Connection;
#
#      fInfoStream: TCP2DataStream;
#      fAggrStream: TCP2DataStream;
#
#      procedure ProcessPlaza2Messages(Sender: TObject; var Done: Boolean);
#
#      procedure ConnectionStatusChanged(Sender: TObject; var conn: OleVariant; newStatus: TConnectionStatus);
#
#      procedure StreamStateChanged(Sender: TObject; var stream: OleVariant; newState: TDataStreamState);
#      procedure StreamLifeNumChanged(Sender: TObject; var stream: OleVariant; LifeNum: Integer);
#
#      procedure StreamDataInserted(Sender: TObject; var stream: OleVariant; var tableName: OleVariant; var rec: OleVariant);
#      procedure StreamDataDeleted(Sender: TObject; var stream: OleVariant; var tableName: OleVariant; Id: Int64; var rec: OleVariant);
#      procedure StreamDataEnd(Sender: TObject; var stream: OleVariant);
#
#      procedure StreamDatumDeleted(Sender: TObject; var stream: OleVariant; var tableName: OleVariant; rev: Int64);
#
#      procedure RedrawOrderBook(forceredraw: boolean);
#    public
#      function CheckAndReopen(AStream: TCP2DataStream): boolean;
#      procedure log(const alogstr: string); overload;
#      procedure log(const alogstr: string; const aparams: array of const); overload;
#    end;
#

  class Client

    attr_accessor :instruments, :orders

    def initialize #: TObject)
      # My modifications:
      @log = []
      @instruments = {}
      #var   OrderBookList   : OrderList
      @orders = OrderList.new
      @stop = false

      # Create P2::Connection object with P2MQRouter connectivity parameters
      # (this implicitly creates P2::Application)
      # ��������� ��� ini-����� � ����������� ����������
      # ������������� ����� ������ � �������� (� ������ ������ - ���������)
      # ��������� ����, � �������� ������������ ��� ����������
      # ������ ������������ ��� ����������
      @conn = P2::Connection.new :ini => CLIENT_INI, :host => 'localhost',
                                 :port => 4001, :AppName => 'P2VCLTestApp'

      # Client will handle Connection's events
      #    OnConnectionStatusChanged = ConnectionStatusChanged
      # ������������� ���������� ��������� ������� ������ (connected, error...)
      @conn.events.handler = self

      # ������� ������ plaza2
      @info_stream = P2::DataStream.new :type => P2::RT_COMBINED_DYNAMIC, :name => STREAM_INFO_NAME
      @info_stream.events.handler = self
      @aggr_stream = P2::DataStream.new :type => P2::RT_COMBINED_DYNAMIC, :name => STREAM_AGGR_NAME
      @aggr_stream.events.handler = self
    end

    # Exception handling wrapper for Win32OLE exceptions.
    # Catch/log Win32OLE exceptions, pass on all others...
    def try
      begin
        yield
      rescue WIN32OLERuntimeError => e #(System.Runtime.InteropServices.COMException e)
        log "Ignoring caught Win32Ole runtime error:  #{e}"
      rescue Exception => e #(System.Exception e)
#    $client.streams.each do |_, stream|
#      puts "#{stream.StreamName}:"
#      pp stream.stats
#      stream.save_revisions
#    end
        log "Raising non-Win32Ole error: #{e}"
        p @log
        raise e
      end
    end

    # Main event cycle
    def run
      until @stop
        try do
          # (Re)-connecting to Router
          @conn.Connect()
          try do
            until @stop
              # Check status for all streams, reopen as necessary
              CheckAndReopen(@info_stream)
              CheckAndReopen(@aggr_stream)

              # Actual processing of incoming messages happens in event callbacks
              # O����������� ��������� ��������� � ����������� ��������� ������
              @conn.ProcessMessage2(100)
            end
          end

          # Make sure streams are closed and disconnect before reconnecting
          @info_stream.Close unless @info_stream.closed?
          @aggr_stream.Close unless @aggr_stream.closed?
          @conn.Disconnect()
        end
      end
    end

#      # ������������� ���������� ��������� plaza2
#    def ProcessPlaza2Messages #(Sender: TObject; var Done: Boolean)
#      # ��������� ������ ������ � ������������� ���, ���� ��� ����������
#      if @conn.connected? && @conn.logged?
#        CheckAndReopen(@info_stream)
#        CheckAndReopen(@aggr_stream)
#      end
#
#      # ��������� ��������� ��������� plaza2
#      @conn.ProcessMessage2 100 if @conn
#    end

    def CheckAndReopen(stream) #: TCP2DataStream): boolean
      try do
        # �������� � ������������ ������
        if stream.closed? || stream.error?
          stream.Close if stream.error?
          stream.Open(@conn)
        end
      end
    end

    def log *args
      puts "#{Time.now.strftime('%Y-%m-%d %H:%M:%S.%3N')}: #{args}"
      # ������ ������ 50 �����
      @log.pop if @log.size > 50
      # ��������� �����y � ������
      @log.unshift "#{Time.now.strftime('%Y-%m-%d %H:%M:%S.%3N')}: #{args}"
    end

    def RedrawOrderBook force
      @orders_changed = true
    end

    # ������������� ���������� ��������� ������� ������ (remote_snapshot, online...)
    def onConnectionStatusChanged(conn, new_status)
      # ������� ��������� �� ��������� ������� ����������
      log "������ ���������� ��������� ��: #{new_status}, #{@conn.status_text(new_status)}"
    end

    def onStreamStateChanged(stream, new_state)
      log "������ ������ #{stream.streamName} ��������� ��: #{new_state}, #{@info_stream.state_text(new_state)}"
    end

    # ������������� ���������� ����� ������ �����, �� ��������� ��� �����������
    # �������� ������ � online
    def onStreamLifeNumChanged(stream, life_num)
      log "Stream #{stream.StreamName} LifeNum changed to #{life_num} "
      # ��� ��������� ������ ����� ������, ��������� ������ ����� ����� �����
      stream.TableSet.LifeNum = life_num

      case stream.streamName
        # ������� �������, �������� ������������
        when STREAM_INFO_NAME
          @instruments.clear
        when STREAM_AGGR_NAME
          @orders.clear
      end

      # ������� ��������� �� ����
    end

    def onStreamDataInserted(stream, table_name, rec)
      log "Stream #{stream.StreamName} inserts into #{table_name} "
      if rec.GetValAsString('replAct').to_i == 0
        stream_name = stream.StreamName
        # ��������� ��������� ������
        if stream_name == STREAM_INFO_NAME && table_name == TABLE_FUTSESS_NAME
          # ����� INFO & ������� fut_sess_contents, ��������� ������ ������������
          isin_id = rec.GetValAsString('isin_id')
          # ��������� ����������, ���� ��� ��� ��� ���
          @instruments[isin_id] ||=
              "#{isin_id}, #{rec.GetValAsString('short_isin')}, #{rec.GetValAsString('name')}"
        elsif stream_name == STREAM_AGGR_NAME && table_name == TABLE_AGGR_NAME
          # ����� AGGR, ��������� ������ � ���� �� ��������
          @orders.addrecord(rec.GetValAsLong('isin_id'),
                           rec.GetValAsString('replID').to_i,
                           rec.GetValAsString('replRev').to_i,
                           rec.GetValAsString('price').to_f,
                           rec.GetValAsString('volume').to_f,
                           rec.GetValAsLong('dir'))
        end
      end
    end

    def onStreamDataDeleted(stream, table_name, id, rec)
      log "Stream #{stream.StreamName} deletes from #{table_name} "
      if stream.StreamName == STREAM_AGGR_NAME && table_name == TABLE_AGGR_NAME
        # ������� ������ �� ������ �� ��������
        @orders.delrecord(id)
      end
    end

    def onStreamDataUpdated(stream, table_name, id, rec)
      log "Stream #{stream.StreamName} updates from #{table_name} "
    end

    def onStreamDatumDeleted(stream, table_name, rev)
      log "Stream #{stream.StreamName} deletes Datum in #{table_name} "
      if stream.StreamName == STREAM_AGGR_NAME && table_name == TABLE_AGGR_NAME
        # ������� ������ �� ���� �������� � ��������� ������ ���������
        @orders.clearbyrev(rev)
        # �������������� ������
        RedrawOrderBook(false)
      end
    end

    def onStreamDataEnd(stream)
      log "Stream #{stream.StreamName} inserts into #{table_name} "
      # ���� ���������� ����� ��������� ������ AGGR, �������������� ������
      RedrawOrderBook(false) if stream.StreamName == STREAM_AGGR_NAME
    end
  end # class
end #module

