unit p2_baseless_VCL_example_main;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms, AppEvnts, StdCtrls, Controls,
  ActiveX, OleServer, ComObj, P2ClientGate_TLB;

// ����� ��� ��������� ������� � ��������� �� ����������
type
  TPreciseTime = class(TComponent)
  private
    fTime: tDateTime;
    fStart: int64;
    fFreq: int64;
  public
    constructor Create(AOwner: TComponent); override;
    function    Now: TDateTime;
    function    Msecs: longint;
  end;

// ������� ����� ����������
type
  TForm1 = class(TForm)
    LogListBox: TListBox;
    ConnectButton: TButton;
    DisconnectButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure DisconnectButtonClick(Sender: TObject);
  private
    fPreciseTime: TPreciseTime;
    fApp: TCP2Application;
    fConn: TCP2Connection;
    fStream: TCP2DataStream;

    procedure ProcessPlaza2Messages(Sender: TObject; var Done: Boolean);

    procedure ConnectionStatusChanged(Sender: TObject; var conn: OleVariant; newStatus: TConnectionStatus);

    procedure StreamStateChanged(Sender: TObject; var stream: OleVariant; newState: TDataStreamState);
    procedure StreamLifeNumChanged(Sender: TObject; var stream: OleVariant; LifeNum: Integer);

    procedure StreamDataBegin(Sender: TObject; var stream: OleVariant);
    procedure StreamDataInserted(Sender: TObject; var stream: OleVariant; var tableName: OleVariant; var rec: OleVariant);
    procedure StreamDataEnd(Sender: TObject; var stream: OleVariant);
  public
    function CheckAndReopen(AStream: TCP2DataStream): boolean;
    procedure log(const alogstr: string); overload;
    procedure log(const alogstr: string; const aparams: array of const); overload;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

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

function TPreciseTime.Msecs: longint;
var fEnd : int64;
begin
  QueryPerformanceCounter(fEnd);
  result:= (fEnd * 1000) div fFreq;
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
  if not fileexists('P2ClientGate.ini') then begin
    // ���� ���� �����������, ������� ���������
    MessageBox(0, '����������� ���� �������� P2ClientGate.ini', '������', 0);
    // ��������� ����������
    PostMessage(Handle, WM_CLOSE, 0, 0);
  end;

  // ������� ��������� ���������� plaza2
  fApp:= TCP2Application.Create(Self);
  // ��������� ��� ini-����� � ����������� ����������
  fApp.StartUp('P2ClientGate.ini');

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

  // ������� ����� plaza2
  fStream  := TCP2DataStream.create(Self);
  with fStream do begin
    // ��������� ����� �������� ������ (� delphi ����� type - ��������, ��� �������
    // ���������� ����� ��� ���� ������������� �������������
    type_:= RT_COMBINED_DYNAMIC;
    // ������ ��� ������, �������� ������ �� ���������
    StreamName:= 'FORTS_FUTTRADE_REPL';

    // ������������� ���������� ��������� ������� ������ (remote_snapshot, online...)
    OnStreamStateChanged:= StreamStateChanged;
    // ������������� ���������� ����� ������ �����, �� ��������� ��� �����������
    // �������� ������ � online
    OnStreamLifeNumChanged:= StreamLifeNumChanged;

    // ������������� ���������� "������ ������"
    OnStreamDataBegin:= StreamDataBegin;
    // ������������� ���������� ��������� ������ (����� �������� ��� ������ ��������� � ListBox)
    OnStreamDataInserted:= StreamDataInserted;
    // ������������� ���������� "����� ������"
    OnStreamDataEnd:= StreamDataEnd;
  end;
end;

procedure TForm1.ProcessPlaza2Messages(Sender: TObject; var Done: Boolean);
var cookie : longword;
begin
  // ��������� ������ ������ � ������������� ���, ���� ��� ����������
  if assigned(fConn) and (fConn.Status and CS_CONNECTION_CONNECTED <> 0) then begin
    CheckAndReopen(fStream);
    // ...
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
  log('Connection status changed to: %.8x', [longint(newStatus)]);
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
  if (st < low(streamstates)) or (st > high(streamstates)) then st:= state_unknown;
  log('Stream %s state changed to %s (%.8x)', [stream.StreamName, streamstates[st], st]);
end;

procedure TForm1.StreamLifeNumChanged(Sender: TObject; var stream: OleVariant; LifeNum: Integer);
begin
  // ��� ��������� ������ ����� ������, ��������� ������ ����� ����� �����
  stream.TableSet.LifeNum:= olevariant(lifenum);
  // ������� ��������� �� ����
  log('Stream %s LifeNum changed to: %d', [string(stream.StreamName), lifenum]);
end;

procedure TForm1.StreamDataBegin(Sender: TObject; var stream: OleVariant);
begin
  // ������� ��������� � ���, ��� ������ ��������� �����
  log('Stream: %s data begin', [string(stream.StreamName)]);
end;

procedure TForm1.StreamDataInserted(Sender: TObject; var stream, tableName, rec: OleVariant);
var i    : longint;
    data : string;
begin
  // ��������� ��������� ������

  // �������� ��� ������ � �������
  data:= format('%s %s ', [string(stream.StreamName), string(tableName)]);
  // ��������������� �������� ��� ���� ������ � ���� ����� � �������� � ������ ��� ������������ ������

  with IP2Record(IUnknown(rec)) do
    for i:= 0 to Count - 1 do data:= data + GetValAsStringByIndex(i) + ',';

  // ������� �������������� ������ � ���
  log(data);
end;

procedure TForm1.StreamDataEnd(Sender: TObject; var stream: OleVariant);
begin
  // ������� ��������� � ���, ��� ��������� ������ ���������
  log('Stream: %s data end', [string(stream.StreamName)]);
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
    on e: exception do log('Connect exception: %s', [e.message]);
  end;
end;

procedure TForm1.DisconnectButtonClick(Sender: TObject);
begin
  // ������ ���������� �� ������ disconnect

  // ��� ������� ���������� ����� ����� Disconnect ��� ������������� ������������ �
  // Disconnect1 ��� ����, ����� �������� ����������� �� ����������� ������� Connect
  // Ole-������� ������
  if assigned(fConn) then try
    fConn.Disconnect1;
  except
    on e: exception do log('Disconnect exception: %s', [e.message]);
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

initialization
  // �������������� COM
  CoInitializeEx(nil, COINIT_APARTMENTTHREADED);

finalization
  CoUnInitialize;

end.
