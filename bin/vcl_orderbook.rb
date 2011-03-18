module VCL

#type  
#  tDuplicates = [:dup_accept, :dup_ignore, :dup_replace]
#      // базовый класс "список" с поддержкой автоматического освобождения элементов
#type  CustomList     = class(tList)
#        procedure   clear; override;
#        procedure   freeitem(item: pointer); virtual; abstract;
#        procedure   freeall; virtual;
#        procedure   delete(index: longint); virtual;
#        procedure   remove(item: pointer); virtual;
#      end;
  class CustomList < Array

    def clear
      (0...size).each { freeitem(self[i]) }
      super
    end

    def freeall
      clear
    end

    def freeitem item
    end

    # Standard #delete_at instead of #delete

    # Deletes ALL items from arr that are equal to obj.?
    # No, we need to remove ONE item by "pointer"
    def remove item #(item: pointer)
      freeitem item
      delete item
    end
  end # class CustomList

#      // базовый класс "сортированный список"
#type  tSortedList     = class(CustomList)
#        fDuplicates   : tDuplicates;
#        constructor create;
#        function    checkitem(item: pointer): boolean; virtual; abstract;
#        function    compare(item1, item2: pointer): longint; virtual; abstract;
#        function    search(item: pointer; var index: longint): boolean; virtual;
#        procedure   add(item: pointer); virtual;
#        procedure   insert(index: longint; item: pointer); virtual;
#      end;
  class SortedList < CustomList

    attr_accessor :duplicates

    def initialize
      @duplicates = :dup_accept
      super
    end

    # Returns true and item's index if item is in the List
    # Returns false and item's index  if item not found
    def search item #(item: pointer; var index: longint): boolean
      result = false
      l = 0
      h = size - 1
      while (l <= h) do
        i = (l + h) >> 1
        case compare(self[i], item)
          when -1
            l = i + 1
          when 1
            h = i - 1
          when 0
            h = i - 1
            result = true
            l = i if @duplicates == :dup_ignore || @duplicates == :dup_replace
        end
      end
      index = l
      [result, index]
    end

    def add item #(item: pointer)
      if checkitem(item)
        result, index = search(item)
        if result
          case @duplicates
            when :dup_accept
              insert(index, item)
            when :dup_ignore
              freeitem(item)
            when :dup_replace
              freeitem(self[index])
              self[index] = item
          end
        else
          insert(index, item)
        end
      else
        freeitem(item)
      end
    end

    def insert index, item #(index: longint; item: pointer)
      if checkitem(item)
        super index, item
      end
    end
  end # class SortedList

#      // индекс стакана по цене
#type  tOrderBook      = class(tSortedList)
#      private
#        fisin_id      : longint;
#        fchanged      : boolean;
#      public
#        procedure   freeitem(item: pointer); override;
#        function    checkitem(item: pointer): boolean; override;
#        function    compare(item1, item2: pointer): longint; override;
#
#        procedure   add(item: pointer); override;
#        procedure   remove(item: pointer); override;
#
#        property    isin_id: longint read fisin_id;
#        property    changed: boolean read fchanged write fchanged;
#      end;
  class OrderBook < SortedList
    attr_accessor :isin_id, :changed

    def initialize isin_id
      @isin_id = isin_id
      super()
    end

    def checkitem item #(item: pointer): boolean
      item.price > 0
    end

    def compare item1, item2 #(item1, item2: pointer): longint
      item1.price <=> item2.price
    end

    def add item #(item: pointer)
      super item
      @changed = true
    end

    def remove item #(item: pointer)
      super item
      @changed = true
    end
  end # class OrderBook

#      // список стаканов
#type  tPriceLists     = class(tSortedList)
#      private
#        tmp_ordbook   : tOrderBook;
#      public
#        destructor  destroy; override;
#        procedure   freeitem(item: pointer); override;
#        function    checkitem(item: pointer): boolean; override;
#        function    compare(item1, item2: pointer): longint; override;
#        function    searchadditem(isin_id: longint): tOrderBook;
#      end;
#
  class OrderBookList < SortedList

    def checkitem item #(item: pointer): boolean
      item
    end

    def compare(item1, item2) #(item1, item2: pointer): longint
      item1.isin_id <=> item2.isin_id;
    end

    def searchadditem(isin_id) #(isin_id: longint): OrderBook
      order_book = OrderBook.new(isin_id)
      exists, idx = search(order_book)
      if exists
        result = self[idx]
      else
        result = order_book
        insert(idx, result)
      end
      result
    end

  end # class OrderBook

#      // общая таблица котировок
#type  OrderList  = class(tSortedList)
#        fOrderBooks   : tPriceLists;
#        constructor create;
#        destructor  destroy; override;
#        procedure   freeitem(item: pointer); override;
#        function    checkitem(item: pointer): boolean; override;
#        function    compare(item1, item2: pointer): longint; override;
#        function    searchadditem(isin_id: longint): tOrderBook;
#        function    addrecord(isin_id: longint; const id, rev: int64; const price, volume: double; buysell: longint): boolean;
#        function    delrecord(const id: int64): boolean;
#        procedure   clearbyrev(const rev: int64);
#      end;
  class OrderList < SortedList
    attr_accessor :order_books

    def initialize
      super
      @order_books = OrderBookList.new
    end

    def freeitem item #(item: pointer)
      item.order_book.remove(item) if item.order_book
    end

    def checkitem item #(item: pointer): boolean
      item
    end

    def compare(item1, item2) #: pointer): longint
      item1.id <=> item2.id
    end

    def searchadditem isin_id #(isin_id: longint): OrderBook
      @order_books.searchadditem(isin_id)
    end

    def addrecord isin_id, id, rev, price, volume, buysell #(isin_id: longint; const id, rev: int64; const price, volume: double; buysell: longint): boolean
      item = OrderBookItem.new
      item.id = id
      result, idx = search(item)
      if result
        item = self[idx]

        if item.price != price # признак, что цена изменилась
          item.order_book.remove(item) if item.order_book # удаляем из стакана
          if price > 0
            item.order_book = searchadditem(isin_id) unless item.order_book
            item.order_book.add(item) if item.order_book # добавляем в стакан
          else
            item.order_book = nil;
          end
        end

        item.rev = rev
        item.price = price
        item.volume = volume
        item.buysell = buysell
      else
        item.rev = rev
        item.price = price
        item.volume = volume
        item.buysell = buysell

        if (item.price > 0)
          item.order_book = searchadditem(isin_id)
          item.order_book.add(item) if item.order_book # добавляем в стакан
        else
          item.order_book = nil
        end
        insert(idx, item) # добавляем в общую таблицу
      end
    end

    def delrecord id #(const id: int64): boolean
      item = OrderBookItem.new
      item.id = id
      result, idx = search(item)
      delete_at(idx) if result # удаляем из общей таблицы
    end

    # Delete all records with rev less than given
    def clearbyrev rev #(const rev: int64)
      (size-1).downto(0) do |i|
        delete_at(i) if self[i].rev < rev # удаляем из общей таблицы
      end
    end

  end #class OrderList

#      // элемент "строка в стакане"
#type  pOrderBookItem  = ^tOrderBookItem;
#      tOrderBookItem  = record
#        id         : int64;
#        rev        : int64;
#        price         : double;  // цена
#        volume        : double;  // кол-во
#        buysell       : longint; // покупка(1)/продажа(2)
#        order_book      : tOrderBook;
#      end;
  class OrderBookItem
    attr_accessor :id, :rev, :price, :volume, :buysell, :order_book

    def inspect
      "#{id}:#{price}>#{volume}#{buysell == 1 ? '+' : '-'}"
    end

    alias to_s inspect
  end

  #######################
  # New hierarchy:
  #######################

  # Abstract (equivalent of SortedList)
  # базовый класс "сортированный список"
  class SortedHash < Hash

    def free item
    end

    def check item
      true
    end

    def index item
      item.object_id
    end

    # Adds new item only if it passes check...
    # TODO: What to do with the item it should have replaced?!
    def add item
      self[index item] = item if check item
#      check item ? super : free key # delete key
    end

    def remove item
      free item
      delete index item
    end

    def clear
      each_value { |item| free item }
      super
    end
  end # SortedHash

  # Represents DOM (OrderBook) for one security
  # индекс стакана по цене
  class DOM < SortedHash
    attr_accessor :isin_id, :changed

    def initialize isin_id
      @isin_id = isin_id
      @changed = false
      super
    end

    def index item
      item.price
    end

    def check item
      item.price > 0
    end

    def add item
      @changed = true # Marking DOM as changed
      super
    end

    def remove item
      @changed = true # Marking DOM as changed
      super
    end
  end # class DOM


  # Represents Hash of DOMs (OrderBooks) indexed by isin_id
  #      список стаканов
  class DOMHash < SortedHash

    def index item
      item.isin_id
    end

    # Always return DOM for isin_id, create one on spot if need be
    def [] isin_id
      super || add(DOM.new isin_id)
    end
  end # class DOMHash

  # Represents Hash of all aggregated orders by (repl) id
  #    общая таблица котировок
  class OrderHash < SortedHash
    attr_accessor :order_books

    def index item
      item.id
    end

    def initialize
      super
      @order_books = DOMHash.new
    end

    # We need to clear item from its order book before scrapping it
    def free item
      item.order_book.remove item if item.order_book
    end

    # Rebooks item to a correct order book, given its price
    def rebook item, book
      if (item.price > 0)
        # item represents new aggr_order with price
        item.order_book = book unless item.order_book
        book.add item # добавляем в стакан
      else
        # item clears previous aggr_order for given price
        item.order_book = nil
      end
    end

    def addrecord isin_id, id, rev, price, volume, buysell
      item = self[id] || OrderBookItem.new

      price_changed = item.price != price # признак, что цена изменилась

      item.id = id
      item.rev = rev
      item.price = price
      item.volume = volume
      item.buysell = buysell

      if price_changed
        if self[id] # item is already here
          item.order_book.remove item if item.order_book # free item - удаляем из стакана
        else # new item
          add item
        end
        rebook item, @order_books[isin_id]
      end
    end

    def delrecord id
      remove self[id] if self[id]
    end

    # Clear all records with rev less than given
    def clearbyrev rev #(const rev: int64)
      each_value { |item| remove item if item.rev < rev } # удаляем из общей таблицы
    end
  end # class OrderHash

end # module

