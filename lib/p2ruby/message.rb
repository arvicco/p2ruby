module P2Ruby
  # Represents P2 Message
  # ������ ������������ ��� �������� ���������. ��� ���� �� ��������� ��� �������� ���������
  # ����������� �� ������ ������ ��������� �� ��������� (�������� � P2ClientGate.ini),
  # � ������������� ����� ������� ���������, ����������� �� ��������� ������.
  # ���� ��������� ������������ ������ ����� ���������, ������� ��� ������������� �������
  # ������� ���������������� ini-����, ���������� ����� �����.
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
    #   ��� ��������� - �������� ini-�����
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
    #   ����� ����������.
    def DestAddr()
      @ole._getproperty(4, [], [])
    end

    # property VOID DestAddr
    #   ����� ����������.
    def DestAddr=(val)
      @ole._setproperty(4, [val], [VT_BSTR])
    end

    # property VARIANT Field
    #   ��������, ����������� ���� ���������. ��� ��������� �� ����� ���� ��������
    #   ��� ������ ��� ��������. � ����������� ��������� �������������� ��������� ����:
    #    ?	P2_From � ��������� ���� � ����������� ���������.
    #    ?	P2_To � ��������� ���� � ���������� ���������.
    #    ?	P2_Type � ������ ����� � ��� ���������.
    #    ?	P2_SendId � ������ ���� � ������������� ���������� ���������.
    #    ?	P2_ReplyId � ������ ���� � ������ �� ������������� ������������� ���������.
    #    ?	P2_Category � ��������� ���� � ��������� ���������.
    #    ?	P2_Body � ���� ���������� ����� � ���� ���������.
    #   ������������ ����� ��������� ���� ���� � ���������.
    #   � ��������� ���� ����� ���������� ��� � ���� ���������, ��������, ����������������
    #   � ���������������� ����, ��� � ���������� �� ����� � ���� Body. ����� ���������
    #   �������� � ini-����� (�� ��������� P2ClientGate.ini). �� ��������� ����� ���������
    #   ������ ��� ����� �� � ������ message. ����� ��������� ������������� ���������
    #   ������, ������������� � �����. ��� �������� ����� ��������� ������������� �����������
    #   �������� �������� ���� �� ���������. �������� �� ��������� ������������� �������������
    #   � ��������� ��� ��� ��������. ��� ��������� �� �������� ������ ��� ��� ���� ���������.
    #   ������ ��������: field=<��� ����>,<���>,,<�������� �� ���������>.
    #     BSTR name [IN]
    def Field
      @_Field ||= OLEProperty.new(@ole, 5, [VT_BSTR], [VT_BSTR, VT_VARIANT])
    end

    # I8 FieldAsLONGLONG: property FieldAsULONGLONG
    #   ������ �������� ����, ����������������� � LONGLONG � ��������� ������� ��������.
    #   ������� ��� ����� ���� u1, u2, u4, u8, i1, i2, i4, i8, a, d, s, t, f.
    #   BSTR name [IN]
    def FieldAsLONGLONG
      @_FieldAsLONGLONG ||= OLEProperty.new(@ole, 10, [VT_BSTR], [VT_BSTR, VT_I8])
    end

    # method IP2BLMessage Send
    #  �������� ��������� ���� Send.
    #   IP2Connection conn [IN]
    #   UI4 timeout [IN]
    #  [out,retval] IP2BLMessage** reply);
    def Send(conn, timeout)
      conn = conn.respond_to?(:ole) ? conn.ole : conn
      reply = @ole._invoke(6, [conn, timeout], [VT_BYREF|VT_DISPATCH, VT_UI4])
      P2::Message.new :ole => reply
    end

    # method VOID Post
    #   �������� ��������� ���� Post.
    #   IP2Connection conn [IN]
    def Post(conn)
      @ole._invoke(7, [conn], [VT_BYREF|VT_DISPATCH])
    end

    # method VOID SendAsync
    #  ����������� �������� ��������� ���� Send (��� ���������� ������).
    #  �	conn � ��������� �� ��������� ����������;
    #  �	timeout � ������� � �������������, � ������� �������� ��������� �������� ���������;
    #  �	event � ��������� �� ��������� ��������� ������ (��������� IP2AsyncMessageEvents).
    #   IP2Connection conn [IN]
    #   UI4 timeout [IN]
    #   DISPATCH event [IN]
    def SendAsync(conn, timeout, event)
      @ole._invoke(8, [conn, timeout, event], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH])
    end

    # method VOID SendAsync2
    #  ����������� �������� ��������� ���� Send. ������� � ���������� � ������ SendAsync.
    #  � ��� ������������ ������ ��������� ��������� ������ (��������� IP2AsyncSendEvent2),
    #  � ����� ���������� �������������� ��������, ��� ��������� ������� ���� ����������
    #  �� ��������� ���������.
    #   IP2Connection conn [IN]
    #   UI4 timeout [IN]
    #   DISPATCH event [IN]
    #   I8 event_param [IN]
    def SendAsync2(conn, timeout, event, event_param)
      @ole._invoke(9, [conn, timeout, event, event_param], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH, VT_I8])
    end
  end
end # module P2Ruby

