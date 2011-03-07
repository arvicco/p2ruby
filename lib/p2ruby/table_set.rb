module P2

  # Represents TableSet.
  # Объект предназначен для работы с клиентской схемой репликации.
  # Объект TableSet содержит один единственный интерфейс — IP2TableSet.
  # Данный объект поддерживает стандартную технологию перечисления в СОМ.
  #
  class TableSet < Base
    CLSID = '{C52E4892-894B-4C03-841F-97E893F7BCAE}'
    PROGID = 'P2ClientGate.P2TableSet.1'

#    include Enumerable

    def initialize opts = {}
      super(opts) do
        if opts[:ini] && opts[:scheme]
          InitFromIni2(opts[:ini], opts[:scheme])
        elsif opts[:ini]
          InitFromIni(opts[:ini], '')
        end
      end
    end

#    # Record text representation
#    def to_s
#      each.join '|' || ''
#    end
#
#    # Access Record's fields by either name or index, encoding is
#    # converted to Windows-1251
#    def [] id
#      case id
#        when Integer
#          GetValAsStringByIndex(id)
#        else
#          GetValAsString(id.to_s)
#      end.force_encoding('IBM866').encode('CP1251', :undef => :replace)
#    end
#
#    # Yields all fields (basis for mixed in Enumerable methods)
#    def each
#      if block_given?
#        (0...Count()).each { |i| yield self[i] }
#      else
#        (0...Count()).map { |i| self[i] }
#      end
#    end
#

    # Auto-generated OLE methods:

    # property I4 Count - Получение числа таблиц, содержащихся в схеме репликации.
    def Count()
      @ole._getproperty(7, [], [])
    end

    # property I4 LifeNum — номер жизни схемы базы данных.
    def LifeNum()
      @ole._getproperty(11, [], [])
    end

    # property VOID LifeNum  — номер жизни схемы базы данных.
    def LifeNum=(val)
      @ole._setproperty(11, [val], [VT_I4])
    end

    # property BSTR FieldList
    #  набор полей из заданной таблицы. Передавая имя таблицы можно получить строку,
    #  в которой перечисляются все поля в этой таблице.
    #      BSTR table_name [IN]
    def FieldList
      @_FieldList ||= OLEProperty.new(@ole, 4, [VT_BSTR], [VT_BSTR, VT_BSTR])
    end

    # I8 rev: property Rev
    #  максимальное значение служебного поля rev (revision) в таблице. Поле rev —
    #  идентификатор изменения записи в таблице. Данный идентификатор используется
    #  для отслеживания рассогласований данных в серверной БД и клиентских базах.
    #  Нумерация полей rev является сквозной в рамках одной таблицы. При создании
    #  и изменении записи полю rev присваивается значение, большее максимального
    #  значения поля rev в таблице.
    #
    #  Свойство позволяет, как читать этот параметр, так и задавать его. Возможность
    #  задавать параметр позволяет организовать получение данных из серверных таблиц,
    #  начиная с определенных значений ревиженов. Для этого следует в данном свойстве
    #  для требуемых таблиц задать значения ревиженов, а затем подставить данный TableSet
    #  в IP2DataStream при открытии потока данных. В частности начальные ревижены, с
    #  которых начнется получение снэпшота с сервера, следует задавать для безбазового
    #  клиента.
    #
    #    BSTR table_name [IN]
    def Rev
      @_rev ||= OLEProperty.new(@ole, 5, [VT_BSTR], [VT_BSTR, VT_I8])
    end

    alias rev Rev

    # property BSTR FieldTypes
    #  ???????? Not documected.............
    #   BSTR table_name [IN]
    def FieldTypes
      @_FieldTypes ||= OLEProperty.new(@ole, 9, [VT_BSTR], [VT_BSTR, VT_BSTR])
    end

    # method VOID InitFromIni
    #  Инициализация объекта и загрузка из ini-файла клиентской схемы репликации.
    #  Имя схемы (CustReplScheme) жестко прошито в коде. Если используется серверная
    #  схема, то загрузка клиентской схемы не требуется.
    #
    #   BSTR struct_file [IN] — файл, содержащий клиентскую схему репликации.
    #   BSTR sign_file [IN]   — не используется.
    def InitFromIni(struct_file, sign_file)
      @ole._invoke(1, [struct_file.to_s, sign_file.to_s], [VT_BSTR, VT_BSTR])
    end

    # method VOID InitFromIni2
    #  Инициализация объекта и загрузка из ini-файла клиентской схемы репликации.
    #  В отличие от метода InitFromIni данная функция позволяет хранить в одном
    #  ini-файле несколько схем для разных потоков репликации и подставлять
    #  конкретному потоку свою схему.
    #
    #   BSTR ini_file_name [IN] — файл, содержащий клиентские схемы репликации.
    #   BSTR scheme_name [IN]   — имя клиентской схемы репликации.
    def InitFromIni2(ini_file_name, scheme_name)
      @ole._invoke(10, [ini_file_name.to_s, scheme_name.to_s], [VT_BSTR, VT_BSTR])
    end

    # method VOID InitFromDB
    #   BSTR connect_string [IN]
    #   BSTR sign_file [IN]
    def InitFromDB(connect_string, sign_file)
      @ole._invoke(2, [connect_string.to_s, sign_file.to_s], [VT_BSTR, VT_BSTR])
    end

    # method VOID SetLifeNumToIni - Сохранение номера жизни схемы в ини файле.
    #   BSTR ini_file_name [IN] — файл, содержащий клиентские схемы репликации.
    def SetLifeNumToIni(ini_file_name)
      @ole._invoke(12, [ini_file_name.to_s], [VT_BSTR])
    end

    # method VOID AddTable
    #   BSTR table_name [IN]
    #   BSTR fieldl_list [IN]
    #   UI8 rev [IN]
    def AddTable(table_name, fieldl_list, rev)
      @ole._invoke(3, [table_name, fieldl_list, rev], [VT_BSTR, VT_BSTR, VT_UI8])
    end

    # method VOID DeleteTable
    #   BSTR table_name [IN]
    def DeleteTable(table_name)
      @ole._invoke(6, [table_name], [VT_BSTR])
    end

    def NewEnum
      @ole._invoke(8, [], [])
    end

    # HRESULT GetScheme
    #   OLE_HANDLE p_val [OUT]
    def GetScheme(p_val)
      keep_lastargs @ole._invoke(1610678272, [p_val], [VT_BYREF|VT_BYREF|VT_DISPATCH])
    end

  end
end # module P2
