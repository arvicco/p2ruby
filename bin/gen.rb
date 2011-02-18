require 'win32ole'
require 'win32ole/property'

# P2Connection Class
class P2ClientGate_P2Connection_1 # CP2Connection
  include WIN32OLE::VARIANT
  attr_reader :lastargs
  attr_reader :dispatch
  attr_reader :clsid
  attr_reader :progid

  def initialize(obj = nil)
    @clsid = "{CCD42082-33E0-49EA-AED3-9FE39978EB56}"
    @progid = "P2ClientGate.P2Connection.1"
    if obj.nil?
      @dispatch = WIN32OLE.new @progid
    else
      @dispatch = obj
    end
  end

  def method_missing(cmd, *arg)
    @dispatch.method_missing(cmd, *arg)
  end

  # I4 Status
  # property Status
  def Status()
    ret = @dispatch._getproperty(1, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR AppName
  # property AppName
  def AppName()
    ret = @dispatch._getproperty(2, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR NodeName
  # property NodeName
  def NodeName()
    ret = @dispatch._getproperty(3, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR Host
  # property Host
  def Host()
    ret = @dispatch._getproperty(4, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # UI4 Port
  # property Port
  def Port()
    ret = @dispatch._getproperty(5, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # UI4 Timeout
  # property Timeout
  def Timeout()
    ret = @dispatch._getproperty(7, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR LoginStr
  # property LoginStr
  def LoginStr()
    ret = @dispatch._getproperty(8, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID AppName
  # property AppName
  def AppName=(arg0)
    ret = @dispatch._setproperty(2, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Host
  # property Host
  def Host=(arg0)
    ret = @dispatch._setproperty(4, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Port
  # property Port
  def Port=(arg0)
    ret = @dispatch._setproperty(5, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Password
  # property Password
  def Password=(arg0)
    ret = @dispatch._setproperty(6, [arg0], [VT_VARIANT])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Timeout
  # property Timeout
  def Timeout=(arg0)
    ret = @dispatch._setproperty(7, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID LoginStr
  # property LoginStr
  def LoginStr=(arg0)
    ret = @dispatch._setproperty(8, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # UI4 Connect
  # method Connect
  def Connect()
    ret = @dispatch._invoke(9, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Disconnect
  # method Disconnect
  def Disconnect()
    ret = @dispatch._invoke(10, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Login
  # method Login
  def Login()
    ret = @dispatch._invoke(11, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Logout
  # method Logout
  def Logout()
    ret = @dispatch._invoke(12, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID ProcessMessage
  # method ProcessMessage
  #   UI4 arg0 --- cookie [OUT]
  #   UI4 arg1 --- pollTimeout [IN]
  def ProcessMessage(arg0, arg1)
    ret = @dispatch._invoke(13, [arg0, arg1], [VT_BYREF|VT_UI4, VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # UI4 RegisterReceiver
  # method RegisterReceiver
  #   IP2MessageReceiver arg0 --- newReceiver [IN]
  def RegisterReceiver(arg0)
    ret = @dispatch._invoke(14, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID UnRegisterReceiver
  # method UnRegisterReceiver
  #   UI4 arg0 --- cookie [IN]
  def UnRegisterReceiver(arg0)
    ret = @dispatch._invoke(15, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR ResolveService
  # method ResolveService
  #   BSTR arg0 --- service [IN]
  def ResolveService(arg0)
    ret = @dispatch._invoke(16, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # UI4 ProcessMessage2
  # method ProcessMessage2
  #   UI4 arg0 --- pollTimeout [IN]
  def ProcessMessage2(arg0)
    ret = @dispatch._invoke(17, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # UI4 Connect2
  # method Connect2
  #   BSTR arg0 --- connStr [IN]
  def Connect2(arg0)
    ret = @dispatch._invoke(18, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # UI4 ProcessMessage3
  # method ProcessMessage3
  #   UI4 arg0 --- pollTimeout [IN]
  def ProcessMessage3(arg0)
    ret = @dispatch._invoke(19, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # HRESULT GetConn
  #   OLE_HANDLE arg0 --- pVal [OUT]
  def GetConn(arg0)
    ret = @dispatch._invoke(1610678272, [arg0], [VT_BYREF|VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # HRESULT GetConnPtr
  #   OLE_HANDLE arg0 --- pVal [OUT]
  def GetConnPtr(arg0)
    ret = @dispatch._invoke(1610678273, [arg0], [VT_BYREF|VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID ConnectionStatusChanged EVENT in IP2ConnectionEvent
  # method ConnectionStatusChanged
  #   IP2Connection arg0 --- conn [IN]
  #   TConnectionStatus arg1 --- newStatus [IN]
  def ConnectionStatusChanged(arg0, arg1)
    ret = @dispatch._invoke(1, [arg0, arg1], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# IP2Connection Interface
module IP2Connection
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # I4 Status
  # property Status
  def Status()
    ret = _getproperty(1, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR AppName
  # property AppName
  def AppName()
    ret = _getproperty(2, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR NodeName
  # property NodeName
  def NodeName()
    ret = _getproperty(3, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR Host
  # property Host
  def Host()
    ret = _getproperty(4, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # UI4 Port
  # property Port
  def Port()
    ret = _getproperty(5, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # UI4 Timeout
  # property Timeout
  def Timeout()
    ret = _getproperty(7, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR LoginStr
  # property LoginStr
  def LoginStr()
    ret = _getproperty(8, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID AppName
  # property AppName
  def AppName=(arg0)
    ret = _setproperty(2, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Host
  # property Host
  def Host=(arg0)
    ret = _setproperty(4, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Port
  # property Port
  def Port=(arg0)
    ret = _setproperty(5, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Password
  # property Password
  def Password=(arg0)
    ret = _setproperty(6, [arg0], [VT_VARIANT])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Timeout
  # property Timeout
  def Timeout=(arg0)
    ret = _setproperty(7, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID LoginStr
  # property LoginStr
  def LoginStr=(arg0)
    ret = _setproperty(8, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # UI4 Connect
  # method Connect
  def Connect()
    ret = _invoke(9, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Disconnect
  # method Disconnect
  def Disconnect()
    ret = _invoke(10, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Login
  # method Login
  def Login()
    ret = _invoke(11, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Logout
  # method Logout
  def Logout()
    ret = _invoke(12, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID ProcessMessage
  # method ProcessMessage
  #   UI4 arg0 --- cookie [OUT]
  #   UI4 arg1 --- pollTimeout [IN]
  def ProcessMessage(arg0, arg1)
    ret = _invoke(13, [arg0, arg1], [VT_BYREF|VT_UI4, VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # UI4 RegisterReceiver
  # method RegisterReceiver
  #   IP2MessageReceiver arg0 --- newReceiver [IN]
  def RegisterReceiver(arg0)
    ret = _invoke(14, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID UnRegisterReceiver
  # method UnRegisterReceiver
  #   UI4 arg0 --- cookie [IN]
  def UnRegisterReceiver(arg0)
    ret = _invoke(15, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR ResolveService
  # method ResolveService
  #   BSTR arg0 --- service [IN]
  def ResolveService(arg0)
    ret = _invoke(16, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # UI4 ProcessMessage2
  # method ProcessMessage2
  #   UI4 arg0 --- pollTimeout [IN]
  def ProcessMessage2(arg0)
    ret = _invoke(17, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # UI4 Connect2
  # method Connect2
  #   BSTR arg0 --- connStr [IN]
  def Connect2(arg0)
    ret = _invoke(18, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # UI4 ProcessMessage3
  # method ProcessMessage3
  #   UI4 arg0 --- pollTimeout [IN]
  def ProcessMessage3(arg0)
    ret = _invoke(19, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# IP2MessageReceiver Dispinterface
module IP2MessageReceiver
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # VOID GetFilter
  # method GetFilter
  #   VARIANT arg0 --- from [OUT]
  #   VARIANT arg1 --- type [OUT]
  #   VARIANT arg2 --- category [OUT]
  def GetFilter(arg0, arg1, arg2)
    ret = _invoke(1, [arg0, arg1, arg2], [VT_BYREF|VT_VARIANT, VT_BYREF|VT_VARIANT, VT_BYREF|VT_VARIANT])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID PutMessage
  # method PutMessage
  #   DISPATCH arg0 --- pMsg [IN]
  def PutMessage(arg0)
    ret = _invoke(2, [arg0], [VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# IP2ConnectionEvent Interface
module IP2ConnectionEvent
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # VOID ConnectionStatusChanged
  # method ConnectionStatusChanged
  #   IP2Connection arg0 --- conn [IN]
  #   TConnectionStatus arg1 --- newStatus [IN]
  def ConnectionStatusChanged(arg0, arg1)
    ret = _invoke(1, [arg0, arg1], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# 
module TConnectionStatus
  include WIN32OLE::VARIANT
  attr_reader :lastargs
  CS_CONNECTION_DISCONNECTED = 1
  CS_CONNECTION_CONNECTED = 2
  CS_CONNECTION_INVALID = 4
  CS_CONNECTION_BUSY = 8
  CS_ROUTER_DISCONNECTED = 65536
  CS_ROUTER_RECONNECTING = 131072
  CS_ROUTER_CONNECTED = 262144
  CS_ROUTER_LOGINFAILED = 524288
  CS_ROUTER_NOCONNECT = 1048576
end

# IP2AsyncMessageEvents Dispinterface
module IP2AsyncMessageEvents
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # HRESULT DeliveryEvent
  # method DeliveryEvent
  #   IP2BLMessage arg0 --- reply [IN]
  #   UI4 arg1 --- errCode [IN]
  def DeliveryEvent(arg0, arg1)
    ret = _invoke(1, [arg0, arg1], [VT_BYREF|VT_DISPATCH, VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# IP2BLMessage Interface
module IP2BLMessage
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # BSTR Name
  # property Name
  def Name()
    ret = _getproperty(1, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # UI4 Id
  # property Id
  def Id()
    ret = _getproperty(2, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR Version
  # property Version
  def Version()
    ret = _getproperty(3, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR DestAddr
  # property DestAddr
  def DestAddr()
    ret = _getproperty(4, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID DestAddr
  # property DestAddr
  def DestAddr=(arg0)
    ret = _setproperty(4, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VARIANT Field
  # property Field
  #   BSTR arg0 --- Name [IN]
  def Field
    OLEProperty.new(self, 5, [VT_BSTR], [VT_BSTR, VT_VARIANT])
  end

  # I8 FieldAsLONGLONG
  # property FieldAsULONGLONG
  #   BSTR arg0 --- Name [IN]
  def FieldAsLONGLONG
    OLEProperty.new(self, 10, [VT_BSTR], [VT_BSTR, "??? NOT SUPPORTED TYPE:`I8'"])
  end

  # IP2BLMessage Send
  # method Send
  #   IP2Connection arg0 --- conn [IN]
  #   UI4 arg1 --- Timeout [IN]
  def Send(arg0, arg1)
    ret = _invoke(6, [arg0, arg1], [VT_BYREF|VT_DISPATCH, VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Post
  # method Post
  #   IP2Connection arg0 --- conn [IN]
  def Post(arg0)
    ret = _invoke(7, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID SendAsync
  # method SendAsync
  #   IP2Connection arg0 --- conn [IN]
  #   UI4 arg1 --- Timeout [IN]
  #   DISPATCH arg2 --- event [IN]
  def SendAsync(arg0, arg1, arg2)
    ret = _invoke(8, [arg0, arg1, arg2], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID SendAsync2
  # method SendAsync2
  #   IP2Connection arg0 --- conn [IN]
  #   UI4 arg1 --- Timeout [IN]
  #   DISPATCH arg2 --- event [IN]
  #   I8 arg3 --- eventParam [IN]
  def SendAsync2(arg0, arg1, arg2, arg3)
    ret = _invoke(9, [arg0, arg1, arg2, arg3], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH, "??? NOT SUPPORTED TYPE:`I8'"])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# IP2AsyncSendEvent2 Interface
module IP2AsyncSendEvent2
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # HRESULT SendAsync2Reply
  # method AsyncSendReply
  #   IP2BLMessage arg0 --- reply [IN]
  #   UI4 arg1 --- errCode [IN]
  #   I8 arg2 --- eventParam [IN]
  def SendAsync2Reply(arg0, arg1, arg2)
    ret = _invoke(1, [arg0, arg1, arg2], [VT_BYREF|VT_DISPATCH, VT_UI4, "??? NOT SUPPORTED TYPE:`I8'"])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# P2BLMessage Class
class P2ClientGate_P2BLMessage_1 # CP2BLMessage
  include WIN32OLE::VARIANT
  attr_reader :lastargs
  attr_reader :dispatch
  attr_reader :clsid
  attr_reader :progid

  def initialize(obj = nil)
    @clsid = "{A9A6C936-5A12-4518-9A92-90D75B41AF18}"
    @progid = "P2ClientGate.P2BLMessage.1"
    if obj.nil?
      @dispatch = WIN32OLE.new @progid
    else
      @dispatch = obj
    end
  end

  def method_missing(cmd, *arg)
    @dispatch.method_missing(cmd, *arg)
  end

  # BSTR Name
  # property Name
  def Name()
    ret = @dispatch._getproperty(1, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # UI4 Id
  # property Id
  def Id()
    ret = @dispatch._getproperty(2, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR Version
  # property Version
  def Version()
    ret = @dispatch._getproperty(3, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR DestAddr
  # property DestAddr
  def DestAddr()
    ret = @dispatch._getproperty(4, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID DestAddr
  # property DestAddr
  def DestAddr=(arg0)
    ret = @dispatch._setproperty(4, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VARIANT Field
  # property Field
  #   BSTR arg0 --- Name [IN]
  def Field
    OLEProperty.new(@dispatch, 5, [VT_BSTR], [VT_BSTR, VT_VARIANT])
  end

  # I8 FieldAsLONGLONG
  # property FieldAsULONGLONG
  #   BSTR arg0 --- Name [IN]
  def FieldAsLONGLONG
    OLEProperty.new(@dispatch, 10, [VT_BSTR], [VT_BSTR, "??? NOT SUPPORTED TYPE:`I8'"])
  end

  # IP2BLMessage Send
  # method Send
  #   IP2Connection arg0 --- conn [IN]
  #   UI4 arg1 --- Timeout [IN]
  def Send(arg0, arg1)
    ret = @dispatch._invoke(6, [arg0, arg1], [VT_BYREF|VT_DISPATCH, VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Post
  # method Post
  #   IP2Connection arg0 --- conn [IN]
  def Post(arg0)
    ret = @dispatch._invoke(7, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID SendAsync
  # method SendAsync
  #   IP2Connection arg0 --- conn [IN]
  #   UI4 arg1 --- Timeout [IN]
  #   DISPATCH arg2 --- event [IN]
  def SendAsync(arg0, arg1, arg2)
    ret = @dispatch._invoke(8, [arg0, arg1, arg2], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID SendAsync2
  # method SendAsync2
  #   IP2Connection arg0 --- conn [IN]
  #   UI4 arg1 --- Timeout [IN]
  #   DISPATCH arg2 --- event [IN]
  #   I8 arg3 --- eventParam [IN]
  def SendAsync2(arg0, arg1, arg2, arg3)
    ret = @dispatch._invoke(9, [arg0, arg1, arg2, arg3], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH, "??? NOT SUPPORTED TYPE:`I8'"])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# P2BLMessageFactory Class
class P2ClientGate_P2BLMessageFactory_1 # CP2BLMessageFactory
  include WIN32OLE::VARIANT
  attr_reader :lastargs
  attr_reader :dispatch
  attr_reader :clsid
  attr_reader :progid

  def initialize(obj = nil)
    @clsid = "{501786DA-CA02-45C1-B815-1C58C383265D}"
    @progid = "P2ClientGate.P2BLMessageFactory.1"
    if obj.nil?
      @dispatch = WIN32OLE.new @progid
    else
      @dispatch = obj
    end
  end

  def method_missing(cmd, *arg)
    @dispatch.method_missing(cmd, *arg)
  end

  # VOID Init
  # method Init
  #   BSTR arg0 --- structFile [IN]
  #   BSTR arg1 --- signFile [IN]
  def Init(arg0, arg1)
    ret = @dispatch._invoke(1, [arg0, arg1], [VT_BSTR, VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # IP2BLMessage CreateMessageByName
  # method CreateMessageByName
  #   BSTR arg0 --- msgName [IN]
  def CreateMessageByName(arg0)
    ret = @dispatch._invoke(2, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # IP2BLMessage CreateMessageById
  # method CreateMessageById
  #   UI4 arg0 --- msgId [IN]
  def CreateMessageById(arg0)
    ret = @dispatch._invoke(3, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# IP2BLMessageFactory Interface
module IP2BLMessageFactory
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # VOID Init
  # method Init
  #   BSTR arg0 --- structFile [IN]
  #   BSTR arg1 --- signFile [IN]
  def Init(arg0, arg1)
    ret = _invoke(1, [arg0, arg1], [VT_BSTR, VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # IP2BLMessage CreateMessageByName
  # method CreateMessageByName
  #   BSTR arg0 --- msgName [IN]
  def CreateMessageByName(arg0)
    ret = _invoke(2, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # IP2BLMessage CreateMessageById
  # method CreateMessageById
  #   UI4 arg0 --- msgId [IN]
  def CreateMessageById(arg0)
    ret = _invoke(3, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# P2TableSet Class
class P2ClientGate_P2TableSet_1 # CP2TableSet
  include WIN32OLE::VARIANT
  attr_reader :lastargs
  attr_reader :dispatch
  attr_reader :clsid
  attr_reader :progid

  def initialize(obj = nil)
    @clsid = "{C52E4892-894B-4C03-841F-97E893F7BCAE}"
    @progid = "P2ClientGate.P2TableSet.1"
    if obj.nil?
      @dispatch = WIN32OLE.new @progid
    else
      @dispatch = obj
    end
  end

  def method_missing(cmd, *arg)
    @dispatch.method_missing(cmd, *arg)
  end

  # I4 Count
  # property Count
  def Count()
    ret = @dispatch._getproperty(7, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # I4 LifeNum
  # property LifeNum
  def LifeNum()
    ret = @dispatch._getproperty(11, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID LifeNum
  # property LifeNum
  def LifeNum=(arg0)
    ret = @dispatch._setproperty(11, [arg0], [VT_I4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR FieldList
  # property FieldList
  #   BSTR arg0 --- tableName [IN]
  def FieldList
    OLEProperty.new(@dispatch, 4, [VT_BSTR], [VT_BSTR, VT_BSTR])
  end

  # I8 rev
  # property Rev
  #   BSTR arg0 --- tableName [IN]
  def rev
    OLEProperty.new(@dispatch, 5, [VT_BSTR], [VT_BSTR, "??? NOT SUPPORTED TYPE:`I8'"])
  end

  # BSTR FieldTypes
  # property FieldTypes
  #   BSTR arg0 --- tableName [IN]
  def FieldTypes
    OLEProperty.new(@dispatch, 9, [VT_BSTR], [VT_BSTR, VT_BSTR])
  end

  # VOID InitFromIni
  # method InitFromIni
  #   BSTR arg0 --- structFile [IN]
  #   BSTR arg1 --- signFile [IN]
  def InitFromIni(arg0, arg1)
    ret = @dispatch._invoke(1, [arg0, arg1], [VT_BSTR, VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID InitFromDB
  # method InitFromDB
  #   BSTR arg0 --- connectString [IN]
  #   BSTR arg1 --- signFile [IN]
  def InitFromDB(arg0, arg1)
    ret = @dispatch._invoke(2, [arg0, arg1], [VT_BSTR, VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID AddTable
  # method AddTable
  #   BSTR arg0 --- tableName [IN]
  #   BSTR arg1 --- fieldlList [IN]
  #   UI8 arg2 --- rev [IN]
  def AddTable(arg0, arg1, arg2)
    ret = @dispatch._invoke(3, [arg0, arg1, arg2], [VT_BSTR, VT_BSTR, "??? NOT SUPPORTED TYPE:`UI8'"])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID DeleteTable
  # method DeleteTable
  #   BSTR arg0 --- tableName [IN]
  def DeleteTable(arg0)
    ret = @dispatch._invoke(6, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID InitFromIni2
  # method InitFromIni2
  #   BSTR arg0 --- iniFileName [IN]
  #   BSTR arg1 --- schemeName [IN]
  def InitFromIni2(arg0, arg1)
    ret = @dispatch._invoke(10, [arg0, arg1], [VT_BSTR, VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID SetLifeNumToIni
  # method SetLifeNumToIni
  #   BSTR arg0 --- iniFileName [IN]
  def SetLifeNumToIni(arg0)
    ret = @dispatch._invoke(12, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # HRESULT GetScheme
  #   OLE_HANDLE arg0 --- pVal [OUT]
  def GetScheme(arg0)
    ret = @dispatch._invoke(1610678272, [arg0], [VT_BYREF|VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# IP2TableSet Interface
module IP2TableSet
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # I4 Count
  # property Count
  def Count()
    ret = _getproperty(7, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # I4 LifeNum
  # property LifeNum
  def LifeNum()
    ret = _getproperty(11, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID LifeNum
  # property LifeNum
  def LifeNum=(arg0)
    ret = _setproperty(11, [arg0], [VT_I4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR FieldList
  # property FieldList
  #   BSTR arg0 --- tableName [IN]
  def FieldList
    OLEProperty.new(self, 4, [VT_BSTR], [VT_BSTR, VT_BSTR])
  end

  # I8 rev
  # property Rev
  #   BSTR arg0 --- tableName [IN]
  def rev
    OLEProperty.new(self, 5, [VT_BSTR], [VT_BSTR, "??? NOT SUPPORTED TYPE:`I8'"])
  end

  # BSTR FieldTypes
  # property FieldTypes
  #   BSTR arg0 --- tableName [IN]
  def FieldTypes
    OLEProperty.new(self, 9, [VT_BSTR], [VT_BSTR, VT_BSTR])
  end

  # VOID InitFromIni
  # method InitFromIni
  #   BSTR arg0 --- structFile [IN]
  #   BSTR arg1 --- signFile [IN]
  def InitFromIni(arg0, arg1)
    ret = _invoke(1, [arg0, arg1], [VT_BSTR, VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID InitFromDB
  # method InitFromDB
  #   BSTR arg0 --- connectString [IN]
  #   BSTR arg1 --- signFile [IN]
  def InitFromDB(arg0, arg1)
    ret = _invoke(2, [arg0, arg1], [VT_BSTR, VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID AddTable
  # method AddTable
  #   BSTR arg0 --- tableName [IN]
  #   BSTR arg1 --- fieldlList [IN]
  #   UI8 arg2 --- rev [IN]
  def AddTable(arg0, arg1, arg2)
    ret = _invoke(3, [arg0, arg1, arg2], [VT_BSTR, VT_BSTR, "??? NOT SUPPORTED TYPE:`UI8'"])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID DeleteTable
  # method DeleteTable
  #   BSTR arg0 --- tableName [IN]
  def DeleteTable(arg0)
    ret = _invoke(6, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID InitFromIni2
  # method InitFromIni2
  #   BSTR arg0 --- iniFileName [IN]
  #   BSTR arg1 --- schemeName [IN]
  def InitFromIni2(arg0, arg1)
    ret = _invoke(10, [arg0, arg1], [VT_BSTR, VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID SetLifeNumToIni
  # method SetLifeNumToIni
  #   BSTR arg0 --- iniFileName [IN]
  def SetLifeNumToIni(arg0)
    ret = _invoke(12, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# P2Record Class
module CP2Record
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # UI4 Count
  # property Count
  def Count()
    ret = _getproperty(1, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR GetValAsString
  # method GetValAsString
  #   BSTR arg0 --- fieldName [IN]
  def GetValAsString(arg0)
    ret = _invoke(2, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR GetValAsStringByIndex
  # method GetValAsStringByIndex
  #   UI4 arg0 --- fieldIndex [IN]
  def GetValAsStringByIndex(arg0)
    ret = _invoke(3, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # I4 GetValAsLong
  # method GetValAsLong
  #   BSTR arg0 --- fieldName [IN]
  def GetValAsLong(arg0)
    ret = _invoke(4, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # I4 GetValAsLongByIndex
  # method GetValAsLongByIndex
  #   UI4 arg0 --- fieldIndex [IN]
  def GetValAsLongByIndex(arg0)
    ret = _invoke(5, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # I2 GetValAsShort
  # method GetValAsShort
  #   BSTR arg0 --- fieldName [IN]
  def GetValAsShort(arg0)
    ret = _invoke(6, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # I2 GetValAsShortByIndex
  # method GetValAsShortByIndex
  #   UI4 arg0 --- fieldIndex [IN]
  def GetValAsShortByIndex(arg0)
    ret = _invoke(7, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VARIANT GetValAsVariant
  # method GetValAsVariant
  #   BSTR arg0 --- fieldName [IN]
  def GetValAsVariant(arg0)
    ret = _invoke(8, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VARIANT GetValAsVariantByIndex
  # method GetValAsVariantByIndex
  #   UI4 arg0 --- fieldIndex [IN]
  def GetValAsVariantByIndex(arg0)
    ret = _invoke(9, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # HRESULT GetRec
  #   OLE_HANDLE arg0 --- pVal [OUT]
  def GetRec(arg0)
    ret = _invoke(1610678272, [arg0], [VT_BYREF|VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# IP2Record Interface
module IP2Record
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # UI4 Count
  # property Count
  def Count()
    ret = _getproperty(1, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR GetValAsString
  # method GetValAsString
  #   BSTR arg0 --- fieldName [IN]
  def GetValAsString(arg0)
    ret = _invoke(2, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR GetValAsStringByIndex
  # method GetValAsStringByIndex
  #   UI4 arg0 --- fieldIndex [IN]
  def GetValAsStringByIndex(arg0)
    ret = _invoke(3, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # I4 GetValAsLong
  # method GetValAsLong
  #   BSTR arg0 --- fieldName [IN]
  def GetValAsLong(arg0)
    ret = _invoke(4, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # I4 GetValAsLongByIndex
  # method GetValAsLongByIndex
  #   UI4 arg0 --- fieldIndex [IN]
  def GetValAsLongByIndex(arg0)
    ret = _invoke(5, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # I2 GetValAsShort
  # method GetValAsShort
  #   BSTR arg0 --- fieldName [IN]
  def GetValAsShort(arg0)
    ret = _invoke(6, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # I2 GetValAsShortByIndex
  # method GetValAsShortByIndex
  #   UI4 arg0 --- fieldIndex [IN]
  def GetValAsShortByIndex(arg0)
    ret = _invoke(7, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VARIANT GetValAsVariant
  # method GetValAsVariant
  #   BSTR arg0 --- fieldName [IN]
  def GetValAsVariant(arg0)
    ret = _invoke(8, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VARIANT GetValAsVariantByIndex
  # method GetValAsVariantByIndex
  #   UI4 arg0 --- fieldIndex [IN]
  def GetValAsVariantByIndex(arg0)
    ret = _invoke(9, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# P2DataStream Class
class P2ClientGate_P2DataStream_1 # CP2DataStream
  include WIN32OLE::VARIANT
  attr_reader :lastargs
  attr_reader :dispatch
  attr_reader :clsid
  attr_reader :progid

  def initialize(obj = nil)
    @clsid = "{914893CB-0864-4FBB-856A-92C3A1D970F8}"
    @progid = "P2ClientGate.P2DataStream.1"
    if obj.nil?
      @dispatch = WIN32OLE.new @progid
    else
      @dispatch = obj
    end
  end

  def method_missing(cmd, *arg)
    @dispatch.method_missing(cmd, *arg)
  end

  # IP2TableSet TableSet
  # property TableSet
  def TableSet()
    ret = @dispatch._getproperty(1, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR StreamName
  # property StreamName
  def StreamName()
    ret = @dispatch._getproperty(2, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR DBConnString
  # property DBConnString
  def DBConnString()
    ret = @dispatch._getproperty(3, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # TRequestType type
  # property Type
  def type()
    ret = @dispatch._getproperty(4, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # TDataStreamState State
  # property State
  def State()
    ret = @dispatch._getproperty(5, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID TableSet
  # property TableSet
  def TableSet=(arg0)
    ret = @dispatch._setproperty(1, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamName
  # property StreamName
  def StreamName=(arg0)
    ret = @dispatch._setproperty(2, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID DBConnString
  # property DBConnString
  def DBConnString=(arg0)
    ret = @dispatch._setproperty(3, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID type
  # property Type
  def type=(arg0)
    ret = @dispatch._setproperty(4, [arg0], [VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Open
  # method Open
  #   IP2Connection arg0 --- conn [IN]
  def Open(arg0)
    ret = @dispatch._invoke(6, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Close
  # method Close
  def Close()
    ret = @dispatch._invoke(7, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # HRESULT GetScheme
  #   OLE_HANDLE arg0 --- pVal [OUT]
  def GetScheme(arg0)
    ret = @dispatch._invoke(1610678272, [arg0], [VT_BYREF|VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # HRESULT LinkDataBuffer
  #   IP2DataStreamEvents arg0 --- dataBuff [IN]
  def LinkDataBuffer(arg0)
    ret = @dispatch._invoke(1610678273, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamStateChanged EVENT in IP2DataStreamEvents
  # method StreamStateChanged
  #   IP2DataStream arg0 --- stream [IN]
  #   TDataStreamState arg1 --- newState [IN]
  def StreamStateChanged(arg0, arg1)
    ret = @dispatch._invoke(1, [arg0, arg1], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataInserted EVENT in IP2DataStreamEvents
  # method StreamDataInserted
  #   IP2DataStream arg0 --- stream [IN]
  #   BSTR arg1 --- tableName [IN]
  #   IP2Record arg2 --- rec [IN]
  def StreamDataInserted(arg0, arg1, arg2)
    ret = @dispatch._invoke(2, [arg0, arg1, arg2], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataUpdated EVENT in IP2DataStreamEvents
  # method StreamDataUpdated
  #   IP2DataStream arg0 --- stream [IN]
  #   BSTR arg1 --- tableName [IN]
  #   I8 arg2 --- Id [IN]
  #   IP2Record arg3 --- rec [IN]
  def StreamDataUpdated(arg0, arg1, arg2, arg3)
    ret = @dispatch._invoke(3, [arg0, arg1, arg2, arg3], [VT_BYREF|VT_DISPATCH, VT_BSTR, "??? NOT SUPPORTED TYPE:`I8'", VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataDeleted EVENT in IP2DataStreamEvents
  # method StreamDataDeleted
  #   IP2DataStream arg0 --- stream [IN]
  #   BSTR arg1 --- tableName [IN]
  #   I8 arg2 --- Id [IN]
  #   IP2Record arg3 --- rec [IN]
  def StreamDataDeleted(arg0, arg1, arg2, arg3)
    ret = @dispatch._invoke(4, [arg0, arg1, arg2, arg3], [VT_BYREF|VT_DISPATCH, VT_BSTR, "??? NOT SUPPORTED TYPE:`I8'", VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDatumDeleted EVENT in IP2DataStreamEvents
  # method StreamDatumDeleted
  #   IP2DataStream arg0 --- stream [IN]
  #   BSTR arg1 --- tableName [IN]
  #   I8 arg2 --- rev [IN]
  def StreamDatumDeleted(arg0, arg1, arg2)
    ret = @dispatch._invoke(5, [arg0, arg1, arg2], [VT_BYREF|VT_DISPATCH, VT_BSTR, "??? NOT SUPPORTED TYPE:`I8'"])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDBWillBeDeleted EVENT in IP2DataStreamEvents
  # method StreamDBWillBeDeleted
  #   IP2DataStream arg0 --- stream [IN]
  def StreamDBWillBeDeleted(arg0)
    ret = @dispatch._invoke(6, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamLifeNumChanged EVENT in IP2DataStreamEvents
  # method StreamLifeNumChanged
  #   IP2DataStream arg0 --- stream [IN]
  #   I4 arg1 --- LifeNum [IN]
  def StreamLifeNumChanged(arg0, arg1)
    ret = @dispatch._invoke(7, [arg0, arg1], [VT_BYREF|VT_DISPATCH, VT_I4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataBegin EVENT in IP2DataStreamEvents
  # method StreamDataBegin
  #   IP2DataStream arg0 --- stream [IN]
  def StreamDataBegin(arg0)
    ret = @dispatch._invoke(8, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataEnd EVENT in IP2DataStreamEvents
  # method StreamDataEnd
  #   IP2DataStream arg0 --- stream [IN]
  def StreamDataEnd(arg0)
    ret = @dispatch._invoke(9, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# IP2DataStream Interface
module IP2DataStream
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # IP2TableSet TableSet
  # property TableSet
  def TableSet()
    ret = _getproperty(1, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR StreamName
  # property StreamName
  def StreamName()
    ret = _getproperty(2, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # BSTR DBConnString
  # property DBConnString
  def DBConnString()
    ret = _getproperty(3, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # TRequestType type
  # property Type
  def type()
    ret = _getproperty(4, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # TDataStreamState State
  # property State
  def State()
    ret = _getproperty(5, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID TableSet
  # property TableSet
  def TableSet=(arg0)
    ret = _setproperty(1, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamName
  # property StreamName
  def StreamName=(arg0)
    ret = _setproperty(2, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID DBConnString
  # property DBConnString
  def DBConnString=(arg0)
    ret = _setproperty(3, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID type
  # property Type
  def type=(arg0)
    ret = _setproperty(4, [arg0], [VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Open
  # method Open
  #   IP2Connection arg0 --- conn [IN]
  def Open(arg0)
    ret = _invoke(6, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Close
  # method Close
  def Close()
    ret = _invoke(7, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# 
module TRequestType
  include WIN32OLE::VARIANT
  attr_reader :lastargs
  RT_LOCAL = 0
  RT_COMBINED_SNAPSHOT = 1
  RT_COMBINED_DYNAMIC = 2
  RT_REMOTE_SNAPSHOT = 3
  RT_REMOVE_DELETED = 4
  RT_REMOTE_ONLINE = 8
end

# 
module TDataStreamState
  include WIN32OLE::VARIANT
  attr_reader :lastargs
  DS_STATE_CLOSE = 0
  DS_STATE_LOCAL_SNAPSHOT = 1
  DS_STATE_REMOTE_SNAPSHOT = 2
  DS_STATE_ONLINE = 3
  DS_STATE_CLOSE_COMPLETE = 4
  DS_STATE_REOPEN = 5
  DS_STATE_ERROR = 6
end

# IP2DataStreamEvents Interface
module IP2DataStreamEvents
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # VOID StreamStateChanged
  # method StreamStateChanged
  #   IP2DataStream arg0 --- stream [IN]
  #   TDataStreamState arg1 --- newState [IN]
  def StreamStateChanged(arg0, arg1)
    ret = _invoke(1, [arg0, arg1], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataInserted
  # method StreamDataInserted
  #   IP2DataStream arg0 --- stream [IN]
  #   BSTR arg1 --- tableName [IN]
  #   IP2Record arg2 --- rec [IN]
  def StreamDataInserted(arg0, arg1, arg2)
    ret = _invoke(2, [arg0, arg1, arg2], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataUpdated
  # method StreamDataUpdated
  #   IP2DataStream arg0 --- stream [IN]
  #   BSTR arg1 --- tableName [IN]
  #   I8 arg2 --- Id [IN]
  #   IP2Record arg3 --- rec [IN]
  def StreamDataUpdated(arg0, arg1, arg2, arg3)
    ret = _invoke(3, [arg0, arg1, arg2, arg3], [VT_BYREF|VT_DISPATCH, VT_BSTR, "??? NOT SUPPORTED TYPE:`I8'", VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataDeleted
  # method StreamDataDeleted
  #   IP2DataStream arg0 --- stream [IN]
  #   BSTR arg1 --- tableName [IN]
  #   I8 arg2 --- Id [IN]
  #   IP2Record arg3 --- rec [IN]
  def StreamDataDeleted(arg0, arg1, arg2, arg3)
    ret = _invoke(4, [arg0, arg1, arg2, arg3], [VT_BYREF|VT_DISPATCH, VT_BSTR, "??? NOT SUPPORTED TYPE:`I8'", VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDatumDeleted
  # method StreamDatumDeleted
  #   IP2DataStream arg0 --- stream [IN]
  #   BSTR arg1 --- tableName [IN]
  #   I8 arg2 --- rev [IN]
  def StreamDatumDeleted(arg0, arg1, arg2)
    ret = _invoke(5, [arg0, arg1, arg2], [VT_BYREF|VT_DISPATCH, VT_BSTR, "??? NOT SUPPORTED TYPE:`I8'"])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDBWillBeDeleted
  # method StreamDBWillBeDeleted
  #   IP2DataStream arg0 --- stream [IN]
  def StreamDBWillBeDeleted(arg0)
    ret = _invoke(6, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamLifeNumChanged
  # method StreamLifeNumChanged
  #   IP2DataStream arg0 --- stream [IN]
  #   I4 arg1 --- LifeNum [IN]
  def StreamLifeNumChanged(arg0, arg1)
    ret = _invoke(7, [arg0, arg1], [VT_BYREF|VT_DISPATCH, VT_I4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataBegin
  # method StreamDataBegin
  #   IP2DataStream arg0 --- stream [IN]
  def StreamDataBegin(arg0)
    ret = _invoke(8, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataEnd
  # method StreamDataEnd
  #   IP2DataStream arg0 --- stream [IN]
  def StreamDataEnd(arg0)
    ret = _invoke(9, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# P2DataBuffer Class
class P2ClientGate_P2DataBuffer_1 # CP2DataBuffer
  include WIN32OLE::VARIANT
  attr_reader :lastargs
  attr_reader :dispatch
  attr_reader :clsid
  attr_reader :progid

  def initialize(obj = nil)
    @clsid = "{30E32F86-2B2A-47E4-A3B9-FDA18197E6E0}"
    @progid = "P2ClientGate.P2DataBuffer.1"
    if obj.nil?
      @dispatch = WIN32OLE.new @progid
    else
      @dispatch = obj
    end
  end

  def method_missing(cmd, *arg)
    @dispatch.method_missing(cmd, *arg)
  end

  # PTR TableRecords
  # property Records
  #   BSTR arg0 --- tableName [IN]
  def TableRecords
    OLEProperty.new(@dispatch, 4, [VT_BSTR], [VT_BSTR, VT_BYREF|VT_DISPATCH])
  end

  # VOID AttachToStream
  # method AttachToStream
  #   IP2DataStream arg0 --- stream [IN]
  def AttachToStream(arg0)
    ret = @dispatch._invoke(1, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID DetachFromStream
  # method DetachFromStream
  def DetachFromStream()
    ret = @dispatch._invoke(2, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # I4 CountTables
  # method CountTables
  def CountTables()
    ret = @dispatch._invoke(3, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # I4 Count
  # method Count
  #   BSTR arg0 --- tableName [IN]
  def Count(arg0)
    ret = @dispatch._invoke(5, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Clear
  # method Clear
  #   BSTR arg0 --- tableName [IN]
  def Clear(arg0)
    ret = @dispatch._invoke(6, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID ClearAll
  # method Clear
  def ClearAll()
    ret = @dispatch._invoke(8, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamStateChanged
  # method StreamStateChanged
  #   IP2DataStream arg0 --- stream [IN]
  #   TDataStreamState arg1 --- newState [IN]
  def StreamStateChanged(arg0, arg1)
    ret = @dispatch._invoke(1, [arg0, arg1], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataInserted
  # method StreamDataInserted
  #   IP2DataStream arg0 --- stream [IN]
  #   BSTR arg1 --- tableName [IN]
  #   IP2Record arg2 --- rec [IN]
  def StreamDataInserted(arg0, arg1, arg2)
    ret = @dispatch._invoke(2, [arg0, arg1, arg2], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataUpdated
  # method StreamDataUpdated
  #   IP2DataStream arg0 --- stream [IN]
  #   BSTR arg1 --- tableName [IN]
  #   I8 arg2 --- Id [IN]
  #   IP2Record arg3 --- rec [IN]
  def StreamDataUpdated(arg0, arg1, arg2, arg3)
    ret = @dispatch._invoke(3, [arg0, arg1, arg2, arg3], [VT_BYREF|VT_DISPATCH, VT_BSTR, "??? NOT SUPPORTED TYPE:`I8'", VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataDeleted
  # method StreamDataDeleted
  #   IP2DataStream arg0 --- stream [IN]
  #   BSTR arg1 --- tableName [IN]
  #   I8 arg2 --- Id [IN]
  #   IP2Record arg3 --- rec [IN]
  def StreamDataDeleted(arg0, arg1, arg2, arg3)
    ret = @dispatch._invoke(4, [arg0, arg1, arg2, arg3], [VT_BYREF|VT_DISPATCH, VT_BSTR, "??? NOT SUPPORTED TYPE:`I8'", VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDatumDeleted
  # method StreamDatumDeleted
  #   IP2DataStream arg0 --- stream [IN]
  #   BSTR arg1 --- tableName [IN]
  #   I8 arg2 --- rev [IN]
  def StreamDatumDeleted(arg0, arg1, arg2)
    ret = @dispatch._invoke(5, [arg0, arg1, arg2], [VT_BYREF|VT_DISPATCH, VT_BSTR, "??? NOT SUPPORTED TYPE:`I8'"])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDBWillBeDeleted
  # method StreamDBWillBeDeleted
  #   IP2DataStream arg0 --- stream [IN]
  def StreamDBWillBeDeleted(arg0)
    ret = @dispatch._invoke(6, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamLifeNumChanged
  # method StreamLifeNumChanged
  #   IP2DataStream arg0 --- stream [IN]
  #   I4 arg1 --- LifeNum [IN]
  def StreamLifeNumChanged(arg0, arg1)
    ret = @dispatch._invoke(7, [arg0, arg1], [VT_BYREF|VT_DISPATCH, VT_I4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataBegin
  # method StreamDataBegin
  #   IP2DataStream arg0 --- stream [IN]
  def StreamDataBegin(arg0)
    ret = @dispatch._invoke(8, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataEnd
  # method StreamDataEnd
  #   IP2DataStream arg0 --- stream [IN]
  def StreamDataEnd(arg0)
    ret = @dispatch._invoke(9, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# IP2DataBuffer Interface
module IP2DataBuffer
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # PTR TableRecords
  # property Records
  #   BSTR arg0 --- tableName [IN]
  def TableRecords
    OLEProperty.new(self, 4, [VT_BSTR], [VT_BSTR, VT_BYREF|VT_DISPATCH])
  end

  # VOID AttachToStream
  # method AttachToStream
  #   IP2DataStream arg0 --- stream [IN]
  def AttachToStream(arg0)
    ret = _invoke(1, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID DetachFromStream
  # method DetachFromStream
  def DetachFromStream()
    ret = _invoke(2, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # I4 CountTables
  # method CountTables
  def CountTables()
    ret = _invoke(3, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # I4 Count
  # method Count
  #   BSTR arg0 --- tableName [IN]
  def Count(arg0)
    ret = _invoke(5, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID Clear
  # method Clear
  #   BSTR arg0 --- tableName [IN]
  def Clear(arg0)
    ret = _invoke(6, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID ClearAll
  # method Clear
  def ClearAll()
    ret = _invoke(8, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# IP2Table Interface
module IP2TableRecords
  include WIN32OLE::VARIANT
  attr_reader :lastargs
end

# P2Application Class
class P2ClientGate_P2Application_1 # CP2Application
  include WIN32OLE::VARIANT
  attr_reader :lastargs
  attr_reader :dispatch
  attr_reader :clsid
  attr_reader :progid

  def initialize(obj = nil)
    @clsid = "{08A95064-05C2-4EF4-8B5D-D6211C2C9880}"
    @progid = "P2ClientGate.P2Application.1"
    if obj.nil?
      @dispatch = WIN32OLE.new @progid
    else
      @dispatch = obj
    end
  end

  def method_missing(cmd, *arg)
    @dispatch.method_missing(cmd, *arg)
  end

  # UI4 ParserType
  # property ParserType
  def ParserType()
    ret = @dispatch._getproperty(3, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID ParserType
  # property ParserType
  def ParserType=(arg0)
    ret = @dispatch._setproperty(3, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StartUp
  # method StartUp
  #   BSTR arg0 --- iniFileName [IN]
  def StartUp(arg0)
    ret = @dispatch._invoke(1, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID CleanUp
  # method CleanUp
  def CleanUp()
    ret = @dispatch._invoke(2, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # IP2Connection CreateP2Connection
  # method CreateP2Connection
  def CreateP2Connection()
    ret = @dispatch._invoke(4, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # IP2BLMessage CreateP2BLMessage
  # method CreateP2BLMessage
  def CreateP2BLMessage()
    ret = @dispatch._invoke(5, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # IP2BLMessageFactory CreateP2BLMessageFactory
  # method CreateP2BLMessageFactory
  def CreateP2BLMessageFactory()
    ret = @dispatch._invoke(6, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # IP2DataBuffer CreateP2DataBuffer
  # method CreateP2DataBuffer
  def CreateP2DataBuffer()
    ret = @dispatch._invoke(7, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # IP2DataStream CreateP2DataStream
  # method CreateP2DataStream
  def CreateP2DataStream()
    ret = @dispatch._invoke(8, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # IP2TableSet CreateP2TableSet
  # method CreateP2TableSet
  def CreateP2TableSet()
    ret = @dispatch._invoke(9, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# IP2Application Interface
module IP2Application
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # UI4 ParserType
  # property ParserType
  def ParserType()
    ret = _getproperty(3, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID ParserType
  # property ParserType
  def ParserType=(arg0)
    ret = _setproperty(3, [arg0], [VT_UI4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StartUp
  # method StartUp
  #   BSTR arg0 --- iniFileName [IN]
  def StartUp(arg0)
    ret = _invoke(1, [arg0], [VT_BSTR])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID CleanUp
  # method CleanUp
  def CleanUp()
    ret = _invoke(2, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # IP2Connection CreateP2Connection
  # method CreateP2Connection
  def CreateP2Connection()
    ret = _invoke(4, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # IP2BLMessage CreateP2BLMessage
  # method CreateP2BLMessage
  def CreateP2BLMessage()
    ret = _invoke(5, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # IP2BLMessageFactory CreateP2BLMessageFactory
  # method CreateP2BLMessageFactory
  def CreateP2BLMessageFactory()
    ret = _invoke(6, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # IP2DataBuffer CreateP2DataBuffer
  # method CreateP2DataBuffer
  def CreateP2DataBuffer()
    ret = _invoke(7, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # IP2DataStream CreateP2DataStream
  # method CreateP2DataStream
  def CreateP2DataStream()
    ret = _invoke(8, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # IP2TableSet CreateP2TableSet
  # method CreateP2TableSet
  def CreateP2TableSet()
    ret = _invoke(9, [], [])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end

# P2TableEnum Class
module CP2TableEnum
  include WIN32OLE::VARIANT
  attr_reader :lastargs
end

# P2RecordEnum Class
module CP2RecordEnum
  include WIN32OLE::VARIANT
  attr_reader :lastargs
end

# 
module OLE__Impl_IP2DataStreamEvents
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # VOID StreamStateChanged
  # method StreamStateChanged
  #   IP2DataStream arg0 --- stream [IN]
  #   TDataStreamState arg1 --- newState [IN]
  def StreamStateChanged(arg0, arg1)
    ret = _invoke(1, [arg0, arg1], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataInserted
  # method StreamDataInserted
  #   IP2DataStream arg0 --- stream [IN]
  #   BSTR arg1 --- tableName [IN]
  #   IP2Record arg2 --- rec [IN]
  def StreamDataInserted(arg0, arg1, arg2)
    ret = _invoke(2, [arg0, arg1, arg2], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataUpdated
  # method StreamDataUpdated
  #   IP2DataStream arg0 --- stream [IN]
  #   BSTR arg1 --- tableName [IN]
  #   I8 arg2 --- Id [IN]
  #   IP2Record arg3 --- rec [IN]
  def StreamDataUpdated(arg0, arg1, arg2, arg3)
    ret = _invoke(3, [arg0, arg1, arg2, arg3], [VT_BYREF|VT_DISPATCH, VT_BSTR, "??? NOT SUPPORTED TYPE:`I8'", VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataDeleted
  # method StreamDataDeleted
  #   IP2DataStream arg0 --- stream [IN]
  #   BSTR arg1 --- tableName [IN]
  #   I8 arg2 --- Id [IN]
  #   IP2Record arg3 --- rec [IN]
  def StreamDataDeleted(arg0, arg1, arg2, arg3)
    ret = _invoke(4, [arg0, arg1, arg2, arg3], [VT_BYREF|VT_DISPATCH, VT_BSTR, "??? NOT SUPPORTED TYPE:`I8'", VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDatumDeleted
  # method StreamDatumDeleted
  #   IP2DataStream arg0 --- stream [IN]
  #   BSTR arg1 --- tableName [IN]
  #   I8 arg2 --- rev [IN]
  def StreamDatumDeleted(arg0, arg1, arg2)
    ret = _invoke(5, [arg0, arg1, arg2], [VT_BYREF|VT_DISPATCH, VT_BSTR, "??? NOT SUPPORTED TYPE:`I8'"])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDBWillBeDeleted
  # method StreamDBWillBeDeleted
  #   IP2DataStream arg0 --- stream [IN]
  def StreamDBWillBeDeleted(arg0)
    ret = _invoke(6, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamLifeNumChanged
  # method StreamLifeNumChanged
  #   IP2DataStream arg0 --- stream [IN]
  #   I4 arg1 --- LifeNum [IN]
  def StreamLifeNumChanged(arg0, arg1)
    ret = _invoke(7, [arg0, arg1], [VT_BYREF|VT_DISPATCH, VT_I4])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataBegin
  # method StreamDataBegin
  #   IP2DataStream arg0 --- stream [IN]
  def StreamDataBegin(arg0)
    ret = _invoke(8, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end

  # VOID StreamDataEnd
  # method StreamDataEnd
  #   IP2DataStream arg0 --- stream [IN]
  def StreamDataEnd(arg0)
    ret = _invoke(9, [arg0], [VT_BYREF|VT_DISPATCH])
    @lastargs = WIN32OLE::ARGV
    ret
  end
end
