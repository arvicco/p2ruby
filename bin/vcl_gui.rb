# encoding: CP1251
require_relative 'adv_vcl_client'

include Fox

class OrderBookView < FXTable
  def initialize(parent, order_book = nil)
    @order_book = order_book
    super(parent, :opts => LAYOUT_FILL | TABLE_READONLY | TABLE_NO_COLSELECT, :width => 305)
    self.setTableSize(20, 3)
    self.rowHeaderWidth = 1
    self.columnHeaderHeight = 1
#    self.showHorzGrid(false)
  end
end

class LogView < FXList
  attr_reader :log

  def initialize(parent, opts, logs=nil)
    super(parent, :opts => opts)
    appendItem 'LogView inited...'
    @logs = logs
    @last_size = 0

    self.connect(SEL_UPDATE) do |sender, sel, data|
      if @last_size < @logs.size
        (@last_size...@logs.size).each do |i|
          prependItem @logs[i]
        end
        @last_size = @logs.size
      end
    end

#    self.connect(SEL_KEYPRESS) do |sender, sel, event|
#       log :critical, event.state
#    end
  end
end

class VCLForm < FXMainWindow

  include ExceptionWrapper

  def initialize(app, client)
    @client = client
    super(app, "P2 Client Order Books", :width => 1100, :height => 1160)
    add_menu_bar
#    app.addSignal("SIGINT") { log "Sigint"; finalize }
#    app.addSignal("SIGTERM") { log "Sigterm"; finalize }

    # Views setup
    splitter = FXSplitter.new(self, :opts => SPLITTER_HORIZONTAL|LAYOUT_FILL)
    @book_view = OrderBookView.new splitter
    @log_view = LogView.new(splitter, LAYOUT_SIDE_TOP, @client.logs)
    # TODO: Set up a repeating chore to process messages at @client?

  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end

  def add_menu_bar
    menu_bar = FXMenuBar.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
    file_menu = FXMenuPane.new(self)
    FXMenuTitle.new(menu_bar, "File", :popupMenu => file_menu)
    exit_cmd = FXMenuCommand.new(file_menu, "Exit")
    exit_cmd.connect(SEL_COMMAND) { finalize }
  end

  # Wrap up @client and GUI Application
  def finalize
    log :info, "Sending Client a signal to stop"
    @client.stop = true
    # Waiting for client to completely stop before exiting
    sleep 0.1 until @client.stopped
    log :info, "Exiting GUI"
    Thread.exit
  end

  #  Logging delegated to @client
  def log *args
    @client.log *args if @client
  end
end

start_router do |router|

  client = VCLClient.new :name => "Gui_vcl_client", :router => router

  @gui_thread = Thread.new do
#    sleep 2
    FXApp.new do |app|
      VCLForm.new(app, client)
      app.create
      app.run
    end
  end

  client.run
  client.log :debug, "Run finished, client finalized"

  # Waiting for GUI thread to finish...
  @gui_thread.join
end


#def onConnectButtonClick(Sender: TObject)
#  begin
#    # установление соединения по кнопке connect
#
#    if assigned(@conn) then
#      try
#      @conn.Connect
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
#  if assigned(@conn) then try
#    @conn.Disconnect
#  except
#    on e: exception do log('Исключение при разрыве соединения: %s', [e.message])
#  end
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

