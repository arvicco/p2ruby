require_relative 'adv_client'

# Replication Stream parameters
AGGR_ID = 'FORTS_FUTAGGR20_REPL'
AGGR_INI = 'spec\files\orders_aggr.ini'
AGGR_PATH = 'log\SaveAggrRev.txt'

DEAL_ID = 'FORTS_FUTTRADE_REPL'
DEAL_INI = 'spec\files\fut_trades.ini'
DEAL_PATH = 'log\SaveDeal.txt'

COMMON_ID = 'FORTS_FUTCOMMON_REPL'
COMMON_INI = 'spec\files\fut_common.ini'
COMMON_PATH = 'log\SaveCommon.txt'

# Main class implementing business logics
class BaselessClient < Client

  attr_accessor :stats, :streams

  def setup
    # Create replication objects for interesting data streams
    @streams =
        {:common => EventedDataStream.new(:client => self,
                                          :name => COMMON_ID,
                                          :ini => COMMON_INI,
                                          :save_path => COMMON_PATH,
                                          :conn => @conn),

         :orders => EventedDataStream.new(:client => self,
                                          :name => AGGR_ID,
                                          :ini => AGGR_INI,
                                          :save_path => AGGR_PATH,
                                          :conn => @conn),

         :deals => EventedDataStream.new(:client => self,
                                         :name => DEAL_ID,
                                         :ini => DEAL_INI,
                                         :save_path => DEAL_PATH,
                                         :conn => @conn)}

    # TODO: tweak #process_record method for @stream[:orders]
  end

#  # Insert record
#  def onStreamDataInserted(stream, table_name, rec)
#    # Interrupt inside event hook bubbles up instead of being caught in main loop...
#    try do
#      log.puts "Stream #{stream.StreamName} inserts into #{table_name} "
#
#      if stream.StreamName == AGGR_ID
#        # This is FORTS_FUTAGGR20_REPL stream event
#        save_aggr(rec, table_name, stream)
#
#      elsif stream.StreamName == DEAL_ID && table_name == 'deal'
#        # This is FORTS_FUTTRADE_REPL stream event
#        # !!!! Saving only records from 'deal' table, not heartbeat or multileg_deal
#        save_data(rec, table_name, @deal_file, stream, "\n", '')
#      end
#    end
#  end
#
#  # Save/log aggregate orders record
#  def save_aggr(rec, table_name, stream)
#    save_data(rec, table_name, log, stream)
#    @aggr_file.puts "replRev=#{@revisions['orders_aggr']}"
#    @aggr_file.flush
#  end
#
#  # Save/log given record data
#  def save_data(rec, table_name, file, stream, divider = '; ', finalizer = nil)
#    @revisions[table_name] = rec.GetValAsLongByIndex(1)
#
#    fields = stream.TableSet.FieldList(table_name) #"deal"]
#    file.puts fields.split(',').map { |f| "#{f}=#{rec.GetValAsString(f)}" }.join divider
#    file.puts(finalizer) if finalizer
#    file.flush
#  end
end

# The main entry point for the application.
router = start_router

begin
  client = BaselessClient.new :name => 'Adv_baseless', :router => router
  client.run
rescue Exception => e
  puts "Caught in main loop: #{e.class}"
  raise e
end
