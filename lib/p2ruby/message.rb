module P2Ruby
  # Represents P2 Message
  # Объект предназначен для создания сообщений. При этом он позволяет при создании сообщений
  # оперировать не только схемой сообщений по умолчанию (заданной в P2ClientGate.ini),
  # а реализовывать набор классов сообщений, создаваемых по различным схемам.
  # Если требуется использовать другие схемы сообщений, следует при инициализации объекта
  # указать пользовательский ini-файл, содержащий такие схемы.
  #
  class Message < P2Class
    CLSID = '{A9A6C936-5A12-4518-9A92-90D75B41AF18}'
    PROGID = 'P2ClientGate.P2BLMessage.1'

    def initialize opts = {}
#      # First we need to obtain Application instance... Yes, it IS freaking weird.
#      error "Connection/Application should be created first" unless P2Ruby::Application.instance

      super opts
    end

    # analyses message as a server reply, returns result text
    def parse_reply
      category = self.Field["P2_Category"]
      type = self.Field["P2_Type"]

      res = "Reply category: #{category}, type #{type}. "

      if category == "FORTS_MSG" && type == 101
        code = self.Field["code"]
        if code == 0
          res += "Adding order Ok, Order_id: #{self.Field["order_id"]}."
        else
          res += "Adding order fail, logic error: #{self.Field["message"]}"
        end
      elsif category == "FORTS_MSG" && type == 100
        res += "Adding order fail, system level error: " +
            "#{self.Field["code"]} #{self.Field["message"]}"
      else
        res += "Unexpected MQ message recieved."
      end
    end

    # Auto-generated OLE methods:

    # property BSTR Name
    #   имя сообщения - согласно ini-файлу
    def Name()
      @ole._getproperty(1, [], [])
    end

    # property UI4 Id
    def Id()
      @ole._getproperty(2, [], [])
    end

    # property BSTR Version
    def Version()
      @ole._getproperty(3, [], [])
    end

    # property BSTR DestAddr
    #   адрес получателя.
    def DestAddr()
      @ole._getproperty(4, [], [])
    end

    # property VOID DestAddr
    #   адрес получателя.
    def DestAddr=(val)
      @ole._setproperty(4, [val], [VT_BSTR])
    end

    # property VARIANT Field
    #   свойство, описывающее поле сообщения. Оно позволяет по имени поля получить
    #   или задать его значение. В стандартном сообщении предопределены следующие поля:
    #    ?	P2_From — текстовое поле — отправитель сообщения.
    #    ?	P2_To — текстовое поле — получатель сообщения.
    #    ?	P2_Type — четыре байта — тип сообщения.
    #    ?	P2_SendId — восемь байт — идентификатор исходящего сообщения.
    #    ?	P2_ReplyId — восемь байт — ссылка на идентификатор оригинального сообщения.
    #    ?	P2_Category — текстовое поле — категория сообщения.
    #    ?	P2_Body — поле переменной длины — тело сообщения.
    #   Пользователь может добавлять свои поля к сообщению.
    #   В сообщении поля могут помещаться как в само сообщение, например, предопределенные
    #   и пользовательские поля, так и собираться по схеме в поле Body. Схема сообщения
    #   задается в ini-файле (по умолчанию P2ClientGate.ini). По умолчанию схема сообщений
    #   задана как схема БД с именем message. Имена сообщений соответствуют названиям
    #   таблиц, перечисленным в схеме. При описании полей сообщения предусмотрена возможность
    #   задавать значение поля по умолчанию. Значение по умолчанию автоматически подставляется
    #   в сообщение при его создании. Это позволяет не задавать каждый раз все поля сообщения.
    #   Формат описания: field=<имя поля>,<тип>,,<значение по умолчанию>.
    #     BSTR name [IN]
    def Field
      @_Field ||= OLEProperty.new(@ole, 5, [VT_BSTR], [VT_BSTR, VT_VARIANT])
    end

    # I8 FieldAsLONGLONG: property FieldAsULONGLONG
    #   выдает значение поля, сконвертированное в LONGLONG с возможной потерей точности.
    #   Валидно для полей типа u1, u2, u4, u8, i1, i2, i4, i8, a, d, s, t, f.
    #   BSTR name [IN]
    def FieldAsLONGLONG
      @_FieldAsLONGLONG ||= OLEProperty.new(@ole, 10, [VT_BSTR], [VT_BSTR, VT_I8])
    end

    # method IP2BLMessage Send
    #  Отправка сообщений типа Send.
    #   IP2Connection conn [IN]
    #   UI4 timeout [IN]
    #  [out,retval] IP2BLMessage** reply);
    def Send(conn, timeout)
      conn = conn.respond_to?(:ole) ? conn.ole : conn
      reply = @ole._invoke(6, [conn, timeout], [VT_BYREF|VT_DISPATCH, VT_UI4])
      P2::Message.new :ole => reply
    end

    # method VOID Post
    #   Отправка сообщений типа Post.
    #   IP2Connection conn [IN]
    def Post(conn)
      @ole._invoke(7, [conn], [VT_BYREF|VT_DISPATCH])
    end

    # method VOID SendAsync
    #  Асинхронная отправка сообщений типа Send (без блокировки потока).
    #  •	conn — указатель на интерфейс соединения;
    #  •	timeout — таймаут в миллисекундах, в течение которого ожидается ответное сообщение;
    #  •	event — указатель на интерфейс обратного вызова (Интерфейс IP2AsyncMessageEvents).
    #   IP2Connection conn [IN]
    #   UI4 timeout [IN]
    #   DISPATCH event [IN]
    def SendAsync(conn, timeout, event)
      @ole._invoke(8, [conn, timeout, event], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH])
    end

    # method VOID SendAsync2
    #  Асинхронная отправка сообщений типа Send. Выпущен в дополнение к методу SendAsync.
    #  В нем используется другой интерфейс обратного вызова (Интерфейс IP2AsyncSendEvent2),
    #  а также передается дополнительный параметр, что позволяет сделать один обработчик
    #  на несколько сообщений.
    #   IP2Connection conn [IN]
    #   UI4 timeout [IN]
    #   DISPATCH event [IN]
    #   I8 event_param [IN]
    def SendAsync2(conn, timeout, event, event_param)
      @ole._invoke(9, [conn, timeout, event, event_param], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH, VT_I8])
    end
  end
end # module P2Ruby

