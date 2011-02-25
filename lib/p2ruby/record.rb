module P2

  # Represents single Table Record.
  # Объект предназначен для работы с записями.
  #
  class Record < Base
    CLSID = '{76033FC9-8BB0-4415-A785-9BF86AAF4E99}'
    PROGID = nil

    include Enumerable

    def initialize opts = {}
      super opts
    end

    # Record text representation
    def to_s
      each.join '|' || ''
    end

    # Access Record's fields by either name or index, encoding is
    # converted to Windows-1251
    def [] id
      case id
        when Integer
          GetValAsStringByIndex(id)
        else
          GetValAsString(id.to_s)
      end.force_encoding('IBM866').encode('CP1251', :undef => :replace)
    end

    # Yields all fields (basis for mixed in Enumerable methods)
    def each
      if block_given?
        (0...Count()).each { |i| yield self[i] }
      else
        (0...Count()).map { |i| self[i] }
      end
    end

    # Auto-generated OLE methods:

    # property UI4 Count
    def Count()
      _getproperty(1, [], [])
    end

    # method BSTR GetValAsString
    #   BSTR field_name [IN]
    def GetValAsString(field_name)
      _invoke(2, [field_name], [VT_BSTR])
    end

    # method BSTR GetValAsStringByIndex
    #   UI4 field_index [IN]
    def GetValAsStringByIndex(field_index)
      _invoke(3, [field_index], [VT_UI4])
    end

    # method I4 GetValAsLong
    #   BSTR field_name [IN]
    def GetValAsLong(field_name)
      _invoke(4, [field_name], [VT_BSTR])
    end

    # method I4 GetValAsLongByIndex
    #   UI4 field_index [IN]
    def GetValAsLongByIndex(field_index)
      _invoke(5, [field_index], [VT_UI4])
    end

    # method I2 GetValAsShort
    #   BSTR field_name [IN]
    def GetValAsShort(field_name)
      _invoke(6, [field_name], [VT_BSTR])
    end

    # method I2 GetValAsShortByIndex
    #   UI4 field_index [IN]
    def GetValAsShortByIndex(field_index)
      _invoke(7, [field_index], [VT_UI4])
    end

    # method VARIANT GetValAsVariant
    #   BSTR field_name [IN]
    def GetValAsVariant(field_name)
      _invoke(8, [field_name], [VT_BSTR])
    end

    # method VARIANT GetValAsVariantByIndex
    #   UI4 field_index [IN]
    def GetValAsVariantByIndex(field_index)
      _invoke(9, [field_index], [VT_UI4])
    end

    # HRESULT GetRec
    #   OLE_HANDLE p_val [OUT]
    def GetRec(p_val)
      keep_lastargs _invoke(1610678272, [p_val], [VT_BYREF|VT_BYREF|VT_DISPATCH])
    end
  end
end # module P2


