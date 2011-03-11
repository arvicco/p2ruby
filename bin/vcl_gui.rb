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
#    # установление соединения по кнопке connect
#
#    # при импорте библиотеки типов метод Connect был автоматически переименован в
#    # Connect1 для того, чтобы избежать пересечения со стандартным методом Connect
#    # Ole-сервера дельфи
#    if assigned(@conn) then
#      try
#      @conn.Connect1
#      except
#      on e : exception do
#        log('Исключение при попытке соединения: %s', [e.message])
#      end
#    end
#  end
#
#def TForm1.DisconnectButtonClick(Sender: TObject)
#begin
#  # разрыв соединения по кнопке disconnect
#
#  # при импорте библиотеки типов метод Disconnect был автоматически переименован в
#  # Disconnect1 для того, чтобы избежать пересечения со стандартным методом Disconnect
#  # Ole-сервера дельфи
#  if assigned(@conn) then try
#    @conn.Disconnect1
#  except
#    on e: exception do log('Исключение при разрыве соединения: %s', [e.message])
#  end
#end
#
#def TForm1.log(const alogstr: string)
#begin
#  # вывод информации в LogListBox
#  if assigned(LogListBox) then with LogListBox.Items do begin
#    # храним только 50 строк
#    if (Count > 50) then Delete(Count - 1)
#    # добавляем строки в начало
#    Insert(0, formatdatetime('hh:nn:ss.zzz ', fPreciseTime.Now) + alogstr)
#  end
#end
#
#def TForm1.log(const alogstr: string; const aparams: array of const)
#begin
#  # вывод лога с форматированием строки
#  log(format(alogstr, aparams))
#end
#
#def TForm1.InstrumentComboBoxChange(Sender: TObject)
#begin
#  # переключаем инструмент в стакане
#  if assigned(Sender) and (Sender is TComboBox) then begin
#    with TComboBox(Sender) do begin
#      # если в комбобоксе что-то выбрано, то устанавливаем isin_id для отрисовывания гридом,
#      # если нет, присваиваем -1
#      if ItemIndex >= 0 then OrderBookGrid.Tag = longint(Items.Objects[ItemIndex])
#                        else OrderBookGrid.Tag = -1
#    end
#    # принудительно перерисовываем стакан
#    RedrawOrderBook(true)
#  end
#end
#
#def TForm1.RedrawOrderBook(forceredraw: boolean)
#var   itm : tOrderBook
#      i   : longint
#const bsn : array[boolean] of longint = (0, 2)
#  # очистка грида
#  def ClearGrid
#  var i : longint
#  begin
#    # устанавливаем кол-во строк = 1
#    OrderBookGrid.RowCount = 1
#    # очищаем ячейки строки
#    for i = 0 to OrderBookGrid.ColCount - 1 do OrderBookGrid.Cells[i, 0] = ''
#  end
#begin
#  # если установлен isin_id для отрисовки
#  if (OrderBookGrid.Tag >= 0) then begin
#    if assigned(@books) then begin
#      # ищем стакан, соответствующий isin_id
#      itm = @books.searchadditem(OrderBookGrid.Tag)
#      # если он есть и изменился либо принудительная отрисовка
#      if assigned(itm) and (forceredraw or itm.changed) then with itm do begin
#        # если стакан не пуст
#        if Count > 0 then begin
#          # устанавливаем кол-во строк в гриде
#          OrderBookGrid.RowCount = Count
#          # заполняем ячейки грида
#          for i = 0 to Count - 1 do
#            with pOrderBookItem(items[i])^ do begin
#              # заполняем цену
#              OrderBookGrid.Cells[1, i] = FloatToStr(price)
#              # помещаем кол-во справа или слева от цены, в зависимости от buysell
#              OrderBookGrid.Cells[bsn[(buysell and 1 == 1)], i]      = FloatToStr(volume)
#              # противоположную ячейку очищаем
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
#  # нужно для корректного перевода из строк, возвращаемых методом GetValAsString, в числа
#  decimalseparator = '.'
#
#  # инициализируем COM
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
## инициализируем COM
#CoInitializeEx(nil, COINIT_APARTMENTTHREADED)
#
#finalization
#CoUnInitialize

