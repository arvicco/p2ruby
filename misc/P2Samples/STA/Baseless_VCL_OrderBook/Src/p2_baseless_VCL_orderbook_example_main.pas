unit p2_baseless_VCL_orderbook_example_main;

interface

uses
  Windows, SysUtils, Classes, ActiveX, Forms, Controls, StdCtrls, Grids,
  P2ClientGate_TLB,
  p2_orderbook_collector, ExtCtrls;

const
  INI_FILE_NAME      = 'P2ClientGate.ini';

  STREAM_INFO_NAME   = 'FORTS_FUTINFO_REPL';
  STREAM_AGGR_NAME   = 'FORTS_FUTAGGR50_REPL';

  TABLE_AGGR_NAME    = 'orders_aggr';
  TABLE_FUTSESS_NAME = 'fut_sess_contents';

// ����� ��� ��������� ������� � ��������� �� ����������
type
  TPreciseTime = class(TComponent)
  private
    fTime: tDateTime;
    fStart: int64;
    fFreq: int64;
  public
    constructor Create(AOwner: TComponent); override;
    function    Now: TDateTime; overload;
  end;

// ������� ����� ����������
type
  TForm1 = class(TForm)
    LogListBox: TListBox;
    ConnectButton: TButton;
    DisconnectButton: TButton;
    InstrumentComboBox: TComboBox;
    OrderBookGrid: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure DisconnectButtonClick(Sender: TObject);
    procedure InstrumentComboBoxChange(Sender: TObject);
  private
    fPreciseTime: TPreciseTime;
    fApp: TCP2Application;
    fConn: TCP2Connection;

    fInfoStream: TCP2DataStream;
    fAggrStream: TCP2DataStream;

    procedure ProcessPlaza2Messages(Sender: TObject; var Done: Boolean);

    procedure ConnectionStatusChanged(Sender: TObject; var conn: OleVariant; newStatus: TConnectionStatus);

    procedure StreamStateChanged(Sender: TObject; var stream: OleVariant; newState: TDataStreamState);
    procedure StreamLifeNumChanged(Sender: TObject; var stream: OleVariant; LifeNum: Integer);

    procedure StreamDataInserted(Sender: TObject; var stream: OleVariant; var tableName: OleVariant; var rec: OleVariant);
    procedure StreamDataDeleted(Sender: TObject; var stream: OleVariant; var tableName: OleVariant; Id: Int64; var rec: OleVariant);
    procedure StreamDataEnd(Sender: TObject; var stream: OleVariant);

    procedure StreamDatumDeleted(Sender: TObject; var stream: OleVariant; var tableName: OleVariant; rev: Int64);

    procedure RedrawOrderBook(forceredraw: boolean);
  public
    function CheckAndReopen(AStream: TCP2DataStream): boolean;
    procedure log(const alogstr: string); overload;
    procedure log(const alogstr: string; const aparams: array of const); overload;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

function _StrToFloatDef(const str: string; Default: extended): extended;
begin if not TextToFloat(PChar(str), Result, fvExtended) then Result:= Default; end;

{ TPreciseTime }

constructor TPreciseTime.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  QueryPerformanceFrequency(fFreq);
  FTime:= SysUtils.now;
  QueryPerformanceCounter(fStart);
end;

function TPreciseTime.Now: TDateTime;
var fEnd : int64;
begin
  QueryPerformanceCounter(fEnd);
  result:= fTime + (((fEnd - fStart) * 1000) div fFreq) / 86400000.0;
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  // ������������� ���������� ������� Application.OnIdle, � ��� �� ����� ���������
  // ��������� ��������� plaza2
  Application.OnIdle:= ProcessPlaza2Messages;

  // ������� ������� �������
  fPreciseTime:= TPreciseTime.Create(Self);

  // ��������� ������� ����������������� �����
  if not fileexists(INI_FILE_NAME) then begin
    // ���� ���� �����������, ������� ���������
    MessageBox(0, '����������� ���� �������� P2ClientGate.ini; ������� ������...', '������', 0);
    // ������� ����
    fileclose(filecreate(INI_FILE_NAME));
  end;

  // ������� ��������� ���������� plaza2
  fApp:= TCP2Application.Create(Self);
  // ��������� ��� ini-����� � ����������� ����������
  fApp.StartUp(INI_FILE_NAME);

  // ������� ���������� plaza2
  fConn:= TCP2Connection.create(Self);
  with fConn do begin
    // ������������� ����� ������ � �������� (� ������ ������ - ���������)
    Host:= 'localhost';
    // ��������� ����, � �������� ������������ ��� ����������
    Port:= 4001;
    // ������ ������������ ��� ����������
    AppName:= 'P2VCLTestApp';
    // ������������� ���������� ��������� ������� ������ (connected, error...)
    OnConnectionStatusChanged:= ConnectionStatusChanged;
  end;

  // ������� ������ plaza2
  fInfoStream  := TCP2DataStream.create(Self);
  with fInfoStream do begin
    // ��������� ����� �������� ������ (� delphi ����� type - ��������, ��� �������
    // ���������� ����� ��� ���� ������������� �������������
    type_:= RT_COMBINED_DYNAMIC;
    // ������ ��� ������, �������� ������ �� ���������
    StreamName:= STREAM_INFO_NAME;
    // ������������� ���������� ��������� ������� ������ (remote_snapshot, online...)
    OnStreamStateChanged:= StreamStateChanged;
    // ������������� ���������� ����� ������ �����, �� ��������� ��� �����������
    // �������� ������ � online
    OnStreamLifeNumChanged:= StreamLifeNumChanged;
    // ������������� ���������� DatumDeleted
    OnStreamDatumDeleted:= StreamDatumDeleted;

    // ������������� ���������� ��������� ������
    OnStreamDataInserted:= StreamDataInserted;
    // ������������� ���������� �������� ������
    OnStreamDataDeleted:= StreamDataDeleted;
    // ������������� ���������� "����� ������"
    OnStreamDataEnd:= StreamDataEnd;
  end;

  fAggrStream  := TCP2DataStream.create(Self);
  with fAggrStream do begin
    // ��������� ����� �������� ������ (� delphi ����� type - ��������, ��� �������
    // ���������� ����� ��� ���� ������������� �������������
    type_:= RT_COMBINED_DYNAMIC;
    // ������ ��� ������, �������� ������ �� ���������
    StreamName:= STREAM_AGGR_NAME;
    // ������������� ���������� ��������� ������� ������ (remote_snapshot, online...)
    OnStreamStateChanged:= StreamStateChanged;
    // ������������� ���������� ����� ������ �����, �� ��������� ��� �����������
    // �������� ������ � online
    OnStreamLifeNumChanged:= StreamLifeNumChanged;
    // ������������� ���������� DatumDeleted
    OnStreamDatumDeleted:= StreamDatumDeleted;

    // ������������� ���������� ��������� ������
    OnStreamDataInserted:= StreamDataInserted;
    // ������������� ���������� �������� ������
    OnStreamDataDeleted:= StreamDataDeleted;
    // ������������� ���������� "����� ������"
    OnStreamDataEnd:= StreamDataEnd;
  end;
end;

procedure TForm1.ProcessPlaza2Messages(Sender: TObject; var Done: Boolean);
const cs_connected = CS_CONNECTION_CONNECTED or CS_ROUTER_CONNECTED;
var cookie : longword;
begin
  // ��������� ������ ������ � ������������� ���, ���� ��� ����������
  if assigned(fConn) and (fConn.Status and cs_connected = cs_connected) then begin
    CheckAndReopen(fInfoStream);
    CheckAndReopen(fAggrStream);
  end;

  // ��������� ��������� ��������� plaza2
  cookie:= 0;
  if assigned(fConn) then fConn.ProcessMessage(cookie, 1);

  // ���������, ��� ��������� �� ���������, ��� ���� ����� vcl �� ������ � �������� ��������� windows
  Done:= false;
end;

function TForm1.CheckAndReopen(AStream: TCP2DataStream): boolean;
begin
  // �������� � ������������ ������
  result:= true;
  if assigned(AStream) then
    with AStream do try
      // ���� ������ ������ - ������ ��� ������
      if (State = DS_STATE_ERROR) or (State = DS_STATE_CLOSE) then begin
        // ���� ������, �� ���������
        if (State = DS_STATE_ERROR) then Close;
        // ����� �������� ������� ��� �����
        if assigned(fConn) then Open(fConn.DefaultInterface);
      end;
    except result:= false; end;
end;

procedure TForm1.ConnectionStatusChanged(Sender: TObject; var conn: OleVariant; newStatus: TConnectionStatus);
begin
  // ������� ��������� �� ��������� ������� ����������
  log('������ ���������� ��������� ��: %.8x', [longint(newStatus)]);
end;

procedure TForm1.StreamStateChanged(Sender: TObject; var stream: OleVariant; newState: TDataStreamState);
const state_unknown = -1;
const streamstates: array[state_unknown..DS_STATE_ERROR] of pChar = ('UNKNOWN', 'DS_STATE_CLOSE',
        'DS_STATE_LOCAL_SNAPSHOT', 'DS_STATE_REMOTE_SNAPSHOT', 'DS_STATE_ONLINE', 'DS_STATE_CLOSE_COMPLETE',
        'DS_STATE_REOPEN', 'DS_STATE_ERROR');
var   st: longint;
begin
  // ������� ��������� �� ��������� ������� ������
  st:= newState;
  if (st <= low(streamstates)) or (st > high(streamstates)) then st:= state_unknown;
  log('����� %s ������ ��������� �� %s (%.8x)', [stream.StreamName, streamstates[st], st]);
end;

procedure TForm1.StreamLifeNumChanged(Sender: TObject; var stream: OleVariant; LifeNum: Integer);
var strmname : string;
begin
  // ��� ��������� ������ ����� ������, ��������� ������ ����� ����� �����
  stream.TableSet.LifeNum:= olevariant(lifenum);

  strmname:= string(stream.StreamName);
  // ������� �������, �������� ������������
  if (CompareText(strmname, STREAM_INFO_NAME) = 0) then begin
    InstrumentComboBox.Items.Clear;
  end else 
  if (CompareText(strmname, STREAM_AGGR_NAME) = 0) then begin
    if assigned(OrderBookList) then OrderBookList.Clear;
  end;

  // ������� ��������� �� ����
  log('����� %s LifeNum ��������� ��: %d', [strmname, lifenum]);
end;

procedure TForm1.StreamDataInserted(Sender: TObject; var stream, tableName, rec: OleVariant);
var isin_id, idx : longint;
    strmname, tblname : string;
begin
  if (StrToInt64Def(rec.GetValAsString('replAct'), 1) = 0) then begin
    strmname := string(stream.StreamName);
    tblname  := string(tableName);
    // ��������� ��������� ������
    if (CompareText(strmname, STREAM_INFO_NAME) = 0) then begin
      // ����� INFO
      if (CompareText(tblname, TABLE_FUTSESS_NAME) = 0) then begin
        // ������� fut_sess_contents, ��������� ������ ������������
        isin_id:= rec.GetValAsString('isin_id');
        with InstrumentComboBox.Items do begin
          // ��������� ���������� combobox, ���� ��� ��� ��� ���
          idx:= IndexOfObject(pointer(isin_id));
          if (idx < 0) then
            Objects[Add(format('%s [%s]', [rec.GetValAsString('short_isin'), rec.GetValAsString('name')]))]:= pointer(isin_id);
        end;
      end;
    end else
    if (CompareText(strmname, STREAM_AGGR_NAME) = 0) then begin
      // ����� AGGR
      if (CompareText(tblname, TABLE_AGGR_NAME) = 0) then begin
        // ��������� ������ � ���� �� ��������
        if assigned(OrderBookList) then OrderBookList.addrecord(rec.GetValAsLong('isin_id'),
                                                                StrToInt64Def(rec.GetValAsString('replID'), 0),
                                                                StrToInt64Def(rec.GetValAsString('replRev'), 0),
                                                                _StrToFloatDef(rec.GetValAsString('price'), 0),
                                                                _StrToFloatDef(rec.GetValAsString('volume'), 0),
                                                                rec.GetValAsLong('dir'));
      end;

    end;
  end;
end;

procedure TForm1.StreamDataDeleted(Sender: TObject; var stream, tableName: OleVariant; Id: Int64; var rec: OleVariant);
var strmname, tblname : string;
begin
  strmname := string(stream.StreamName);
  tblname  := string(tableName);
  if (CompareText(strmname, STREAM_AGGR_NAME) = 0) then begin
    // ����� AGGR
    if (CompareText(tblname, TABLE_AGGR_NAME) = 0) then begin
      // ������� ������ �� ������ �� ��������
      if assigned(OrderBookList) then OrderBookList.delrecord(Id);
    end;
  end;
end;

procedure TForm1.StreamDatumDeleted(Sender: TObject; var stream, tableName: OleVariant; rev: Int64);
var strmname, tblname : string;
begin
  strmname := string(stream.StreamName);
  tblname  := string(tableName);
  if (CompareText(strmname, STREAM_AGGR_NAME) = 0) then begin
    // ����� AGGR
    if (CompareText(tblname, TABLE_AGGR_NAME) = 0) then begin
      // ������� ������ �� ���� �������� � ��������� ������ ���������
      if assigned(OrderBookList) then OrderBookList.clearbyrev(rev);
      // �������������� ������
      RedrawOrderBook(false);
    end;
  end;
end;

procedure TForm1.StreamDataEnd(Sender: TObject; var stream: OleVariant);
var strmname : string;
begin
  strmname := string(stream.StreamName);
  if (CompareText(strmname, STREAM_AGGR_NAME) = 0) then begin
    // ���� ���������� ����� ��������� ������ AGGR, �������������� ������
    RedrawOrderBook(false);
  end;
end;


procedure TForm1.ConnectButtonClick(Sender: TObject);
begin
  // ������������ ���������� �� ������ connect

  // ��� ������� ���������� ����� ����� Connect ��� ������������� ������������ �
  // Connect1 ��� ����, ����� �������� ����������� �� ����������� ������� Connect
  // Ole-������� ������
  if assigned(fConn) then try
    fConn.Connect1;
  except
    on e: exception do log('���������� ��� ������� ����������: %s', [e.message]);
  end;
end;

procedure TForm1.DisconnectButtonClick(Sender: TObject);
begin
  // ������ ���������� �� ������ disconnect

  // ��� ������� ���������� ����� ����� Disconnect ��� ������������� ������������ �
  // Disconnect1 ��� ����, ����� �������� ����������� �� ����������� ������� Disconnect
  // Ole-������� ������
  if assigned(fConn) then try
    fConn.Disconnect1;
  except
    on e: exception do log('���������� ��� ������� ����������: %s', [e.message]);
  end;
end;

procedure TForm1.log(const alogstr: string);
begin
  // ����� ���������� � LogListBox
  if assigned(LogListBox) then with LogListBox.Items do begin
    // ������ ������ 50 �����
    if (Count > 50) then Delete(Count - 1);
    // ��������� ������ � ������
    Insert(0, formatdatetime('hh:nn:ss.zzz ', fPreciseTime.Now) + alogstr);
  end;
end;

procedure TForm1.log(const alogstr: string; const aparams: array of const);
begin
  // ����� ���� � ��������������� ������
  log(format(alogstr, aparams));
end;

procedure TForm1.InstrumentComboBoxChange(Sender: TObject);
begin
  // ����������� ���������� � �������
  if assigned(Sender) and (Sender is TComboBox) then begin
    with TComboBox(Sender) do begin
      // ���� � ���������� ���-�� �������, �� ������������� isin_id ��� ������������� ������,
      // ���� ���, ����������� -1
      if ItemIndex >= 0 then OrderBookGrid.Tag:= longint(Items.Objects[ItemIndex])
                        else OrderBookGrid.Tag:= -1;
    end;
    // ������������� �������������� ������
    RedrawOrderBook(true);
  end;
end;

procedure TForm1.RedrawOrderBook(forceredraw: boolean);
var   itm : tOrderBook;
      i   : longint;
const bsn : array[boolean] of longint = (0, 2);
  // ������� �����
  procedure ClearGrid;
  var i : longint;
  begin
    // ������������� ���-�� ����� = 1
    OrderBookGrid.RowCount:= 1;
    // ������� ������ ������
    for i:= 0 to OrderBookGrid.ColCount - 1 do OrderBookGrid.Cells[i, 0]:= '';
  end;
begin
  // ���� ���������� isin_id ��� ���������
  if (OrderBookGrid.Tag >= 0) then begin
    if assigned(OrderBookList) then begin
      // ���� ������, ��������������� isin_id
      itm:= OrderBookList.searchadditem(OrderBookGrid.Tag);
      // ���� �� ���� � ��������� ���� �������������� ���������
      if assigned(itm) and (forceredraw or itm.changed) then with itm do begin
        // ���� ������ �� ����
        if Count > 0 then begin
          // ������������� ���-�� ����� � �����
          OrderBookGrid.RowCount:= Count;
          // ��������� ������ �����
          for i:= 0 to Count - 1 do
            with pOrderBookItem(items[i])^ do begin
              // ��������� ����
              OrderBookGrid.Cells[1, i]:= FloatToStr(price);
              // �������� ���-�� ������ ��� ����� �� ����, � ����������� �� buysell
              OrderBookGrid.Cells[bsn[(buysell and 1 = 1)], i]     := FloatToStr(volume);
              // ��������������� ������ �������
              OrderBookGrid.Cells[bsn[not (buysell and 1 = 1)], i] := '';
            end;
        end else ClearGrid;
        changed:= false;
      end;
    end;
  end else ClearGrid;
end;

initialization
  // ����� ��� ����������� �������� �� �����, ������������ ������� GetValAsString, � �����
  decimalseparator:= '.';

  // �������������� COM
  CoInitializeEx(nil, COINIT_APARTMENTTHREADED);

finalization
  CoUnInitialize;

end.
