# encoding: CP1251
require_relative 'adv_vcl_client'

include Fox

class OrderBookView < FXTable
  def initialize p, order_books, selector
    @order_books = order_books
    @selector = selector
    super(p, :opts => LAYOUT_FILL|TABLE_READONLY|TABLE_NO_COLSELECT, :width => 305)
    self.setTableSize(20, 3)
    self.rowHeaderWidth = 1
    self.columnHeaderHeight = 1

    self.connect(SEL_UPDATE) do |sender, sel, data|
      unless @selector.currentItem == -1
        isin = @selector.getItem(@selector.currentItem)[0..5].to_i
        puts isin
        book = @order_books.searchadditem(isin)
        book.each
        puts book
        unless book.empty?
          self.setTableSize(book.size, 3)
          book.each_with_index do |book_item, i| #price, :volume, :buysell
#            p i, book_item
#            p book_item.price.to_s
            self.setItemText(i, 1, book_item.price.to_s)
            col = (book_item.buysell - 1) * 2
            self.setItemText(i, col, book_item.volume.to_s)
          end
        end
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
      end
    end
  end
end

class LogView < FXList
  attr_reader :logs

  def initialize(p, logs=nil)
    super(p, :opts => LAYOUT_SIDE_TOP)
    @logs = logs

    self.connect(SEL_UPDATE) do |sender, sel, data|
      (numItems...@logs.size).each { |i| prependItem @logs[i] }
    end
  end
end

class InstrumentsView < FXListBox
  def initialize(p, instruments)
    super(p, :opts => LISTBOX_NORMAL|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_X)
    self.numVisible = 50
    @instruments = instruments

    self.connect(SEL_UPDATE) do |sender, sel, data|
      (numItems...@instruments.size).each { |i| prependItem @instruments[i].encode('UTF-8') }
#      puts getItem(currentItem) unless currentItem == -1
    end
  end
end

class Button < FXButton
  def initialize p, text, enable = true, &block
    super(p, text, :opts => BUTTON_NORMAL|LAYOUT_RIGHT) {} # suppress yielding to &block
    self.connect(SEL_COMMAND, &block)
    self.enabled = enable
  end
end

class VCLForm < FXMainWindow

  include ExceptionWrapper

  def initialize(app, client)
    @client = client
    super(app, "P2 Client Order Books", :width => 1200, :height => 1200)
    top_frame = FXHorizontalFrame.new(self, :opts => LAYOUT_SIDE_TOP|LAYOUT_FILL_X)

    # Top frame layout
    add_menu_bar top_frame
    add_buttons top_frame
    @instruments_view = InstrumentsView.new top_frame, @client.instruments

    # Split bottom layout
    splitter = FXSplitter.new(self, :opts => SPLITTER_HORIZONTAL|LAYOUT_FILL)
    @order_book_view = OrderBookView.new splitter, @client.orders.order_books, @instruments_view
    @log_view = LogView.new splitter, @client.logs

    # TODO: Set up a repeating chore to process messages at @client?
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end

  def add_menu_bar frame = self
    menu_bar = FXMenuBar.new(frame, LAYOUT_SIDE_TOP|LAYOUT_LEFT)
    file_menu = FXMenuPane.new(self)
    FXMenuTitle.new(menu_bar, "&File", :popupMenu => file_menu)
    exit_cmd = FXMenuCommand.new(file_menu, "&Exit")
    exit_cmd.connect(SEL_COMMAND) { finalize }
  end

  def add_buttons frame = self
    @disconnect_button = Button.new(frame, "&Disconnect", false) do |sender, sel, data|
      log :info, "Pretend to disconnect"
      sender.enabled = false
      @connect_button.enabled = true
    end

    @connect_button = Button.new(frame, "&Connect") do |sender, sel, data|
      log :info, "Pretend to connect"
      sender.enabled = false
      @disconnect_button.enabled = true
    end

    exit_button = Button.new(frame, "&Exit") { finalize }
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

  # Making @client main Object's instance var to avoid segfault on exit
  @client = VCLClient.new :name => "Gui_vcl_client", :router => router

  @gui_thread = Thread.new do
#    sleep 2
    FXApp.new do |app|
      VCLForm.new(app, @client)
      app.create
      app.run
    end
  end

  @client.run
  @client.log :debug, "Run finished, client finalized"

end

# Waiting for GUI thread to finish...
@gui_thread.join

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

