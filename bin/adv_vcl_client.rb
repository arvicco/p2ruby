require_relative 'vcl_orderbook'
require_relative 'adv_client'

# Globals
######################################

# Replication Stream parameters
INFO_ID = 'FORTS_FUTINFO_REPL'
INFO_PATH = 'log\SaveInfo.txt'

AGGR_ID = 'FORTS_FUTAGGR20_REPL'
AGGR_INI = 'spec\files\orders_aggr.ini'
AGGR_PATH = 'log\SaveAggrRev.txt'

DEAL_ID = 'FORTS_FUTTRADE_REPL'
DEAL_INI = 'spec\files\fut_trades.ini'
DEAL_PATH = 'log\SaveDeal.txt'

COMMON_ID = 'FORTS_FUTCOMMON_REPL'
COMMON_INI = 'spec\files\fut_common.ini'
COMMON_PATH = 'log\SaveCommon.txt'

class OrderStream < EventedDataStream
  # устанавливаем обработчик смены номера жизни, он необходим для корректного
  # перехода потока в online
  def onStreamLifeNumChanged(stream, life_num)
    @client.orders.clear
    super
  end

  def onStreamDataInserted(stream, table_name, rec)
    # поток AGGR, добавляем строку в один из стаканов
    @client.orders.addrecord(rec.GetValAsLong('isin_id'),
                             rec.GetValAsString('replID').to_i,
                             rec.GetValAsString('replRev').to_i,
                             rec.GetValAsString('price').to_f,
                             rec.GetValAsString('volume').to_f,
                             rec.GetValAsLong('dir'))
    super
  end

  def onStreamDataDeleted(stream, table_name, id, rec)
    # удаляем строку из одного из стаканов
    @client.orders.delrecord(id)
    super
  end

  def onStreamDatumDeleted(stream, table_name, rev)
    # удаляем строки из всех стаканов с ревиженом меньше заданного
    @client.orders.clearbyrev(rev)
    # перерисовываем стакан
    @client.RedrawOrderBook(false)
    super
  end

  def onStreamDataEnd(stream)
    @client.RedrawOrderBook(false)
    super
  end
end # class OrderStream

class InfoStream < EventedDataStream
  # устанавливаем обработчик смены номера жизни, он необходим для корректного
  # перехода потока в online
  def onStreamLifeNumChanged(stream, life_num)
    @client.instruments.clear
    super
  end

  def onStreamDataInserted(stream, table_name, rec)
    # поток INFO & таблица fut_sess_contents, формируем список инструментов
    if table_name == 'fut_sess_contents'
      isin_id = rec.GetValAsString('isin_id')
      # добавляем инструмент, если его еще нет
      @client.instruments[isin_id] ||=
          "#{isin_id}, #{rec.GetValAsString('short_isin')}, #{rec.GetValAsString('name')}"
    end
    super
  end
end # class InfoStream

# Advanced Client subclass dealing with VCL OrderBook example
class VCLClient < Client
  ## Overriden inherited methods

  attr_accessor :logs, :orders, :instruments

  # Specific setup for Client subclasses
  def setup
    super

    @logs = []
    @instruments = {}
    @orders = VCL::OrderList.new

    # Create replication objects for interesting data streams
    @streams =
        {:common => EventedDataStream.new(:client => self,
                                          :name => COMMON_ID,
                                          :ini => COMMON_INI,
                                          :save_path => COMMON_PATH,
                                          :conn => @conn),

         :orders => OrderStream.new(:client => self,
                                    :name => AGGR_ID,
                                    :ini => AGGR_INI,
                                    :save_path => AGGR_PATH,
                                    :conn => @conn),

         :info => InfoStream.new(:client => self,
                                 :name => INFO_ID,
                                 :save_path => INFO_PATH,
                                 :conn => @conn),
        }

    # TODO: tweak #process_record method for @stream[:orders]

    # Setting up outputs:
    @outputs << @orders.order_books
  end

  def log *args
    super

    # храним только 50 строк
    @logs.pop if @logs.size > 50
    # добавляем строкy в начало
    @logs.unshift "#{Time.now.strftime('%Y-%m-%d %H:%M:%S.%3N')}: #{args}"
  end

  ## VCLClient-specific methods
  def RedrawOrderBook force
    @orders_changed = true
  end
end # class VCLClient

# The main entry point for the application.
router = start_router

begin
  client = VCLClient.new "Adv_vcl_client", router
  client.run
rescue Exception => e
  puts "Caught in main loop: #{e.class}"
  raise e
end
