# encoding: CP1251
require_relative 'vcl_client'
require 'pp'

include Fox

class VCLForm < FXMainWindow
  def initialize(app)
    super(app, "P2 Client Order book", :width => 400, :height => 400)
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end
end

start_router do
#  Thread.new do
#    app = FXApp.new
#    VCLForm.new(app)
#    app.create
#    app.run
#  end
  client = VCL::Client.new
  client.run
end

#def onConnectButtonClick(Sender
#  : TObject)
#  begin
#    # ������������ ���������� �� ������ connect
#
#    # ��� ������� ���������� ����� ����� Connect ��� ������������� ������������ �
#    # Connect1 ��� ����, ����� �������� ����������� �� ����������� ������� Connect
#    # Ole-������� ������
#    if assigned(@conn) then
#      try
#      @conn.Connect1
#      except
#      on e : exception do
#        log('���������� ��� ������� ����������: %s', [e.message])
#      end
#    end
#  end
#
#def TForm1.DisconnectButtonClick(Sender: TObject)
#begin
#  # ������ ���������� �� ������ disconnect
#
#  # ��� ������� ���������� ����� ����� Disconnect ��� ������������� ������������ �
#  # Disconnect1 ��� ����, ����� �������� ����������� �� ����������� ������� Disconnect
#  # Ole-������� ������
#  if assigned(@conn) then try
#    @conn.Disconnect1
#  except
#    on e: exception do log('���������� ��� ������� ����������: %s', [e.message])
#  end
#end
#
#def TForm1.log(const alogstr: string)
#begin
#  # ����� ���������� � LogListBox
#  if assigned(LogListBox) then with LogListBox.Items do begin
#    # ������ ������ 50 �����
#    if (Count > 50) then Delete(Count - 1)
#    # ��������� ������ � ������
#    Insert(0, formatdatetime('hh:nn:ss.zzz ', fPreciseTime.Now) + alogstr)
#  end
#end
#
#def TForm1.log(const alogstr: string; const aparams: array of const)
#begin
#  # ����� ���� � ��������������� ������
#  log(format(alogstr, aparams))
#end
#
#def TForm1.InstrumentComboBoxChange(Sender: TObject)
#begin
#  # ����������� ���������� � �������
#  if assigned(Sender) and (Sender is TComboBox) then begin
#    with TComboBox(Sender) do begin
#      # ���� � ���������� ���-�� �������, �� ������������� isin_id ��� ������������� ������,
#      # ���� ���, ����������� -1
#      if ItemIndex >= 0 then OrderBookGrid.Tag = longint(Items.Objects[ItemIndex])
#                        else OrderBookGrid.Tag = -1
#    end
#    # ������������� �������������� ������
#    RedrawOrderBook(true)
#  end
#end
#
#def TForm1.RedrawOrderBook(forceredraw: boolean)
#var   itm : tOrderBook
#      i   : longint
#const bsn : array[boolean] of longint = (0, 2)
#  # ������� �����
#  def ClearGrid
#  var i : longint
#  begin
#    # ������������� ���-�� ����� = 1
#    OrderBookGrid.RowCount = 1
#    # ������� ������ ������
#    for i = 0 to OrderBookGrid.ColCount - 1 do OrderBookGrid.Cells[i, 0] = ''
#  end
#begin
#  # ���� ���������� isin_id ��� ���������
#  if (OrderBookGrid.Tag >= 0) then begin
#    if assigned(@books) then begin
#      # ���� ������, ��������������� isin_id
#      itm = @books.searchadditem(OrderBookGrid.Tag)
#      # ���� �� ���� � ��������� ���� �������������� ���������
#      if assigned(itm) and (forceredraw or itm.changed) then with itm do begin
#        # ���� ������ �� ����
#        if Count > 0 then begin
#          # ������������� ���-�� ����� � �����
#          OrderBookGrid.RowCount = Count
#          # ��������� ������ �����
#          for i = 0 to Count - 1 do
#            with pOrderBookItem(items[i])^ do begin
#              # ��������� ����
#              OrderBookGrid.Cells[1, i] = FloatToStr(price)
#              # �������� ���-�� ������ ��� ����� �� ����, � ����������� �� buysell
#              OrderBookGrid.Cells[bsn[(buysell and 1 == 1)], i]      = FloatToStr(volume)
#              # ��������������� ������ �������
#              OrderBookGrid.Cells[bsn[not (buysell and 1 == 1)], i]  = ''
#            end
#        end else ClearGrid
#        changed = false
#      end
#    end
#  end else ClearGrid
#end
#
#initialization
#  # ����� ��� ����������� �������� �� �����, ������������ ������� GetValAsString, � �����
#  decimalseparator = '.'
#
#  # �������������� COM
#  CoInitializeEx(nil, COINIT_APARTMENTTHREADED)
#
#finalization
#  CoUnInitialize
#
#end.
#
#
#Form1 = TForm1.new
#
#initialization
## �������������� COM
#CoInitializeEx(nil, COINIT_APARTMENTTHREADED)
#
#finalization
#CoUnInitialize

