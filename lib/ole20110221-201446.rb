require 'win32ole'
require 'win32ole/property'

# P2Connection Class
class CP2Connection < Base # P2ClientGate_P2Connection_1
  CLSID = '{CCD42082-33E0-49EA-AED3-9FE39978EB56}'
  PROGID = 'P2ClientGate.P2Connection.1'
  include WIN32OLE::VARIANT
  attr_reader :lastargs
  attr_reader :ole

  def initialize opts = {}
    super PROGID, opts
  end

  def method_missing(cmd, *args)
    @ole.method_missing(cmd, *args)
  end

  def keep_lastargs(return_value)
    @lastargs = WIN32OLE::ARGV
    return_value
  end

  def clsid
    CLSID
  end

  def progid
    PROGID
  end

  # property I4 Status
  def Status()
    @ole._getproperty(1, [], [])
  end

  # property BSTR AppName
  def AppName()
    @ole._getproperty(2, [], [])
  end

  # property BSTR NodeName
  def NodeName()
    @ole._getproperty(3, [], [])
  end

  # property BSTR Host
  def Host()
    @ole._getproperty(4, [], [])
  end

  # property UI4 Port
  def Port()
    @ole._getproperty(5, [], [])
  end

  # property UI4 Timeout
  def Timeout()
    @ole._getproperty(7, [], [])
  end

  # property BSTR LoginStr
  def LoginStr()
    @ole._getproperty(8, [], [])
  end

  # property VOID AppName
  def AppName=(val)
    @ole._setproperty(2, [val], [VT_BSTR])
  end

  # property VOID Host
  def Host=(val)
    @ole._setproperty(4, [val], [VT_BSTR])
  end

  # property VOID Port
  def Port=(val)
    @ole._setproperty(5, [val], [VT_UI4])
  end

  # property VOID Password
  def Password=(val)
    @ole._setproperty(6, [val], [VT_VARIANT])
  end

  # property VOID Timeout
  def Timeout=(val)
    @ole._setproperty(7, [val], [VT_UI4])
  end

  # property VOID LoginStr
  def LoginStr=(val)
    @ole._setproperty(8, [val], [VT_BSTR])
  end

  # method UI4 Connect
  def Connect()
    @ole._invoke(9, [], [])
  end

  # method VOID Disconnect
  def Disconnect()
    @ole._invoke(10, [], [])
  end

  # method VOID Login
  def Login()
    @ole._invoke(11, [], [])
  end

  # method VOID Logout
  def Logout()
    @ole._invoke(12, [], [])
  end

  # method VOID ProcessMessage
  #   UI4 cookie [OUT]
  #   UI4 poll_timeout [IN]
  def ProcessMessage(cookie, poll_timeout)
    keep_lastargs @ole._invoke(13, [cookie, poll_timeout], [VT_BYREF|VT_UI4, VT_UI4])
  end

  # method UI4 RegisterReceiver
  #   IP2MessageReceiver new_receiver [IN]
  def RegisterReceiver(new_receiver)
    @ole._invoke(14, [new_receiver], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID UnRegisterReceiver
  #   UI4 cookie [IN]
  def UnRegisterReceiver(cookie)
    @ole._invoke(15, [cookie], [VT_UI4])
  end

  # method BSTR ResolveService
  #   BSTR service [IN]
  def ResolveService(service)
    @ole._invoke(16, [service], [VT_BSTR])
  end

  # method UI4 ProcessMessage2
  #   UI4 poll_timeout [IN]
  def ProcessMessage2(poll_timeout)
    @ole._invoke(17, [poll_timeout], [VT_UI4])
  end

  # method UI4 Connect2
  #   BSTR conn_str [IN]
  def Connect2(conn_str)
    @ole._invoke(18, [conn_str], [VT_BSTR])
  end

  # method UI4 ProcessMessage3
  #   UI4 poll_timeout [IN]
  def ProcessMessage3(poll_timeout)
    @ole._invoke(19, [poll_timeout], [VT_UI4])
  end

  # HRESULT GetConn
  #   OLE_HANDLE p_val [OUT]
  def GetConn(p_val)
    keep_lastargs @ole._invoke(1610678272, [p_val], [VT_BYREF|VT_BYREF|VT_DISPATCH])
  end

  # HRESULT GetConnPtr
  #   OLE_HANDLE p_val [OUT]
  def GetConnPtr(p_val)
    keep_lastargs @ole._invoke(1610678273, [p_val], [VT_BYREF|VT_BYREF|VT_DISPATCH])
  end

  # method VOID ConnectionStatusChanged - EVENT in IP2ConnectionEvent
  #   IP2Connection conn [IN]
  #   TConnectionStatus new_status [IN]
  def ConnectionStatusChanged(conn, new_status)
    @ole._invoke(1, [conn, new_status], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
  end
end

# IP2Connection Interface
module IP2Connection
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # property I4 Status
  def Status()
    _getproperty(1, [], [])
  end

  # property BSTR AppName
  def AppName()
    _getproperty(2, [], [])
  end

  # property BSTR NodeName
  def NodeName()
    _getproperty(3, [], [])
  end

  # property BSTR Host
  def Host()
    _getproperty(4, [], [])
  end

  # property UI4 Port
  def Port()
    _getproperty(5, [], [])
  end

  # property UI4 Timeout
  def Timeout()
    _getproperty(7, [], [])
  end

  # property BSTR LoginStr
  def LoginStr()
    _getproperty(8, [], [])
  end

  # property VOID AppName
  def AppName=(val)
    _setproperty(2, [val], [VT_BSTR])
  end

  # property VOID Host
  def Host=(val)
    _setproperty(4, [val], [VT_BSTR])
  end

  # property VOID Port
  def Port=(val)
    _setproperty(5, [val], [VT_UI4])
  end

  # property VOID Password
  def Password=(val)
    _setproperty(6, [val], [VT_VARIANT])
  end

  # property VOID Timeout
  def Timeout=(val)
    _setproperty(7, [val], [VT_UI4])
  end

  # property VOID LoginStr
  def LoginStr=(val)
    _setproperty(8, [val], [VT_BSTR])
  end

  # method UI4 Connect
  def Connect()
    _invoke(9, [], [])
  end

  # method VOID Disconnect
  def Disconnect()
    _invoke(10, [], [])
  end

  # method VOID Login
  def Login()
    _invoke(11, [], [])
  end

  # method VOID Logout
  def Logout()
    _invoke(12, [], [])
  end

  # method VOID ProcessMessage
  #   UI4 cookie [OUT]
  #   UI4 poll_timeout [IN]
  def ProcessMessage(cookie, poll_timeout)
    keep_lastargs _invoke(13, [cookie, poll_timeout], [VT_BYREF|VT_UI4, VT_UI4])
  end

  # method UI4 RegisterReceiver
  #   IP2MessageReceiver new_receiver [IN]
  def RegisterReceiver(new_receiver)
    _invoke(14, [new_receiver], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID UnRegisterReceiver
  #   UI4 cookie [IN]
  def UnRegisterReceiver(cookie)
    _invoke(15, [cookie], [VT_UI4])
  end

  # method BSTR ResolveService
  #   BSTR service [IN]
  def ResolveService(service)
    _invoke(16, [service], [VT_BSTR])
  end

  # method UI4 ProcessMessage2
  #   UI4 poll_timeout [IN]
  def ProcessMessage2(poll_timeout)
    _invoke(17, [poll_timeout], [VT_UI4])
  end

  # method UI4 Connect2
  #   BSTR conn_str [IN]
  def Connect2(conn_str)
    _invoke(18, [conn_str], [VT_BSTR])
  end

  # method UI4 ProcessMessage3
  #   UI4 poll_timeout [IN]
  def ProcessMessage3(poll_timeout)
    _invoke(19, [poll_timeout], [VT_UI4])
  end
end

# IP2MessageReceiver Dispinterface
module IP2MessageReceiver
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # method VOID GetFilter
  #   VARIANT from [OUT]
  #   VARIANT type [OUT]
  #   VARIANT category [OUT]
  def GetFilter(from, type, category)
    keep_lastargs _invoke(1, [from, type, category], [VT_BYREF|VT_VARIANT, VT_BYREF|VT_VARIANT, VT_BYREF|VT_VARIANT])
  end

  # method VOID PutMessage
  #   DISPATCH p_msg [IN]
  def PutMessage(p_msg)
    _invoke(2, [p_msg], [VT_DISPATCH])
  end
end

# IP2ConnectionEvent Interface
module IP2ConnectionEvent
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # method VOID ConnectionStatusChanged
  #   IP2Connection conn [IN]
  #   TConnectionStatus new_status [IN]
  def ConnectionStatusChanged(conn, new_status)
    _invoke(1, [conn, new_status], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
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

  # method HRESULT DeliveryEvent
  #   IP2BLMessage reply [IN]
  #   UI4 err_code [IN]
  def DeliveryEvent(reply, err_code)
    _invoke(1, [reply, err_code], [VT_BYREF|VT_DISPATCH, VT_UI4])
  end
end

# IP2BLMessage Interface
module IP2BLMessage
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # property BSTR Name
  def Name()
    _getproperty(1, [], [])
  end

  # property UI4 Id
  def Id()
    _getproperty(2, [], [])
  end

  # property BSTR Version
  def Version()
    _getproperty(3, [], [])
  end

  # property BSTR DestAddr
  def DestAddr()
    _getproperty(4, [], [])
  end

  # property VOID DestAddr
  def DestAddr=(val)
    _setproperty(4, [val], [VT_BSTR])
  end

  # property VARIANT Field
  #   BSTR name [IN]
  def Field
    @_Field ||= OLEProperty.new(self, 5, [VT_BSTR], [VT_BSTR, VT_VARIANT])
  end

  # I8 FieldAsLONGLONG: property FieldAsULONGLONG
  #   BSTR name [IN]
  def FieldAsLONGLONG
    @_FieldAsLONGLONG ||= OLEProperty.new(self, 10, [VT_BSTR], [VT_BSTR, VT_I8])
  end

  # method IP2BLMessage Send
  #   IP2Connection conn [IN]
  #   UI4 timeout [IN]
  def Send(conn, timeout)
    _invoke(6, [conn, timeout], [VT_BYREF|VT_DISPATCH, VT_UI4])
  end

  # method VOID Post
  #   IP2Connection conn [IN]
  def Post(conn)
    _invoke(7, [conn], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID SendAsync
  #   IP2Connection conn [IN]
  #   UI4 timeout [IN]
  #   DISPATCH event [IN]
  def SendAsync(conn, timeout, event)
    _invoke(8, [conn, timeout, event], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH])
  end

  # method VOID SendAsync2
  #   IP2Connection conn [IN]
  #   UI4 timeout [IN]
  #   DISPATCH event [IN]
  #   I8 event_param [IN]
  def SendAsync2(conn, timeout, event, event_param)
    _invoke(9, [conn, timeout, event, event_param], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH, VT_I8])
  end
end

# IP2AsyncSendEvent2 Interface
module IP2AsyncSendEvent2
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # HRESULT SendAsync2Reply: method AsyncSendReply
  #   IP2BLMessage reply [IN]
  #   UI4 err_code [IN]
  #   I8 event_param [IN]
  def SendAsync2Reply(reply, err_code, event_param)
    _invoke(1, [reply, err_code, event_param], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_I8])
  end
end

# P2BLMessage Class
class CP2BLMessage < Base # P2ClientGate_P2BLMessage_1
  CLSID = '{A9A6C936-5A12-4518-9A92-90D75B41AF18}'
  PROGID = 'P2ClientGate.P2BLMessage.1'
  include WIN32OLE::VARIANT
  attr_reader :lastargs
  attr_reader :ole

  def initialize opts = {}
    super PROGID, opts
  end

  def method_missing(cmd, *args)
    @ole.method_missing(cmd, *args)
  end

  def keep_lastargs(return_value)
    @lastargs = WIN32OLE::ARGV
    return_value
  end

  def clsid
    CLSID
  end

  def progid
    PROGID
  end

  # property BSTR Name
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
  def DestAddr()
    @ole._getproperty(4, [], [])
  end

  # property VOID DestAddr
  def DestAddr=(val)
    @ole._setproperty(4, [val], [VT_BSTR])
  end

  # property VARIANT Field
  #   BSTR name [IN]
  def Field
    @_Field ||= OLEProperty.new(@ole, 5, [VT_BSTR], [VT_BSTR, VT_VARIANT])
  end

  # I8 FieldAsLONGLONG: property FieldAsULONGLONG
  #   BSTR name [IN]
  def FieldAsLONGLONG
    @_FieldAsLONGLONG ||= OLEProperty.new(@ole, 10, [VT_BSTR], [VT_BSTR, VT_I8])
  end

  # method IP2BLMessage Send
  #   IP2Connection conn [IN]
  #   UI4 timeout [IN]
  def Send(conn, timeout)
    @ole._invoke(6, [conn, timeout], [VT_BYREF|VT_DISPATCH, VT_UI4])
  end

  # method VOID Post
  #   IP2Connection conn [IN]
  def Post(conn)
    @ole._invoke(7, [conn], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID SendAsync
  #   IP2Connection conn [IN]
  #   UI4 timeout [IN]
  #   DISPATCH event [IN]
  def SendAsync(conn, timeout, event)
    @ole._invoke(8, [conn, timeout, event], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH])
  end

  # method VOID SendAsync2
  #   IP2Connection conn [IN]
  #   UI4 timeout [IN]
  #   DISPATCH event [IN]
  #   I8 event_param [IN]
  def SendAsync2(conn, timeout, event, event_param)
    @ole._invoke(9, [conn, timeout, event, event_param], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH, VT_I8])
  end
end

# P2BLMessageFactory Class
class CP2BLMessageFactory < Base # P2ClientGate_P2BLMessageFactory_1
  CLSID = '{501786DA-CA02-45C1-B815-1C58C383265D}'
  PROGID = 'P2ClientGate.P2BLMessageFactory.1'
  include WIN32OLE::VARIANT
  attr_reader :lastargs
  attr_reader :ole

  def initialize opts = {}
    super PROGID, opts
  end

  def method_missing(cmd, *args)
    @ole.method_missing(cmd, *args)
  end

  def keep_lastargs(return_value)
    @lastargs = WIN32OLE::ARGV
    return_value
  end

  def clsid
    CLSID
  end

  def progid
    PROGID
  end

  # method VOID Init
  #   BSTR struct_file [IN]
  #   BSTR sign_file [IN]
  def Init(struct_file, sign_file)
    @ole._invoke(1, [struct_file, sign_file], [VT_BSTR, VT_BSTR])
  end

  # method IP2BLMessage CreateMessageByName
  #   BSTR msg_name [IN]
  def CreateMessageByName(msg_name)
    @ole._invoke(2, [msg_name], [VT_BSTR])
  end

  # method IP2BLMessage CreateMessageById
  #   UI4 msg_id [IN]
  def CreateMessageById(msg_id)
    @ole._invoke(3, [msg_id], [VT_UI4])
  end
end

# IP2BLMessageFactory Interface
module IP2BLMessageFactory
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # method VOID Init
  #   BSTR struct_file [IN]
  #   BSTR sign_file [IN]
  def Init(struct_file, sign_file)
    _invoke(1, [struct_file, sign_file], [VT_BSTR, VT_BSTR])
  end

  # method IP2BLMessage CreateMessageByName
  #   BSTR msg_name [IN]
  def CreateMessageByName(msg_name)
    _invoke(2, [msg_name], [VT_BSTR])
  end

  # method IP2BLMessage CreateMessageById
  #   UI4 msg_id [IN]
  def CreateMessageById(msg_id)
    _invoke(3, [msg_id], [VT_UI4])
  end
end

# P2TableSet Class
class CP2TableSet < Base # P2ClientGate_P2TableSet_1
  CLSID = '{C52E4892-894B-4C03-841F-97E893F7BCAE}'
  PROGID = 'P2ClientGate.P2TableSet.1'
  include WIN32OLE::VARIANT
  attr_reader :lastargs
  attr_reader :ole

  def initialize opts = {}
    super PROGID, opts
  end

  def method_missing(cmd, *args)
    @ole.method_missing(cmd, *args)
  end

  def keep_lastargs(return_value)
    @lastargs = WIN32OLE::ARGV
    return_value
  end

  def clsid
    CLSID
  end

  def progid
    PROGID
  end

  # property I4 Count
  def Count()
    @ole._getproperty(7, [], [])
  end

  # property I4 LifeNum
  def LifeNum()
    @ole._getproperty(11, [], [])
  end

  # property VOID LifeNum
  def LifeNum=(val)
    @ole._setproperty(11, [val], [VT_I4])
  end

  # property BSTR FieldList
  #   BSTR table_name [IN]
  def FieldList
    @_FieldList ||= OLEProperty.new(@ole, 4, [VT_BSTR], [VT_BSTR, VT_BSTR])
  end

  # I8 rev: property Rev
  #   BSTR table_name [IN]
  def rev
    @_rev ||= OLEProperty.new(@ole, 5, [VT_BSTR], [VT_BSTR, VT_I8])
  end

  # property BSTR FieldTypes
  #   BSTR table_name [IN]
  def FieldTypes
    @_FieldTypes ||= OLEProperty.new(@ole, 9, [VT_BSTR], [VT_BSTR, VT_BSTR])
  end

  # method VOID InitFromIni
  #   BSTR struct_file [IN]
  #   BSTR sign_file [IN]
  def InitFromIni(struct_file, sign_file)
    @ole._invoke(1, [struct_file, sign_file], [VT_BSTR, VT_BSTR])
  end

  # method VOID InitFromDB
  #   BSTR connect_string [IN]
  #   BSTR sign_file [IN]
  def InitFromDB(connect_string, sign_file)
    @ole._invoke(2, [connect_string, sign_file], [VT_BSTR, VT_BSTR])
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

  # method VOID InitFromIni2
  #   BSTR ini_file_name [IN]
  #   BSTR scheme_name [IN]
  def InitFromIni2(ini_file_name, scheme_name)
    @ole._invoke(10, [ini_file_name, scheme_name], [VT_BSTR, VT_BSTR])
  end

  # method VOID SetLifeNumToIni
  #   BSTR ini_file_name [IN]
  def SetLifeNumToIni(ini_file_name)
    @ole._invoke(12, [ini_file_name], [VT_BSTR])
  end

  # HRESULT GetScheme
  #   OLE_HANDLE p_val [OUT]
  def GetScheme(p_val)
    keep_lastargs @ole._invoke(1610678272, [p_val], [VT_BYREF|VT_BYREF|VT_DISPATCH])
  end
end

# IP2TableSet Interface
module IP2TableSet
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # property I4 Count
  def Count()
    _getproperty(7, [], [])
  end

  # property I4 LifeNum
  def LifeNum()
    _getproperty(11, [], [])
  end

  # property VOID LifeNum
  def LifeNum=(val)
    _setproperty(11, [val], [VT_I4])
  end

  # property BSTR FieldList
  #   BSTR table_name [IN]
  def FieldList
    @_FieldList ||= OLEProperty.new(self, 4, [VT_BSTR], [VT_BSTR, VT_BSTR])
  end

  # I8 rev: property Rev
  #   BSTR table_name [IN]
  def rev
    @_rev ||= OLEProperty.new(self, 5, [VT_BSTR], [VT_BSTR, VT_I8])
  end

  # property BSTR FieldTypes
  #   BSTR table_name [IN]
  def FieldTypes
    @_FieldTypes ||= OLEProperty.new(self, 9, [VT_BSTR], [VT_BSTR, VT_BSTR])
  end

  # method VOID InitFromIni
  #   BSTR struct_file [IN]
  #   BSTR sign_file [IN]
  def InitFromIni(struct_file, sign_file)
    _invoke(1, [struct_file, sign_file], [VT_BSTR, VT_BSTR])
  end

  # method VOID InitFromDB
  #   BSTR connect_string [IN]
  #   BSTR sign_file [IN]
  def InitFromDB(connect_string, sign_file)
    _invoke(2, [connect_string, sign_file], [VT_BSTR, VT_BSTR])
  end

  # method VOID AddTable
  #   BSTR table_name [IN]
  #   BSTR fieldl_list [IN]
  #   UI8 rev [IN]
  def AddTable(table_name, fieldl_list, rev)
    _invoke(3, [table_name, fieldl_list, rev], [VT_BSTR, VT_BSTR, VT_UI8])
  end

  # method VOID DeleteTable
  #   BSTR table_name [IN]
  def DeleteTable(table_name)
    _invoke(6, [table_name], [VT_BSTR])
  end

  # method VOID InitFromIni2
  #   BSTR ini_file_name [IN]
  #   BSTR scheme_name [IN]
  def InitFromIni2(ini_file_name, scheme_name)
    _invoke(10, [ini_file_name, scheme_name], [VT_BSTR, VT_BSTR])
  end

  # method VOID SetLifeNumToIni
  #   BSTR ini_file_name [IN]
  def SetLifeNumToIni(ini_file_name)
    _invoke(12, [ini_file_name], [VT_BSTR])
  end
end

# P2Record Class
module CP2Record
  include WIN32OLE::VARIANT
  attr_reader :lastargs

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

# IP2Record Interface
module IP2Record
  include WIN32OLE::VARIANT
  attr_reader :lastargs

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
end

# P2DataStream Class
class CP2DataStream < Base # P2ClientGate_P2DataStream_1
  CLSID = '{914893CB-0864-4FBB-856A-92C3A1D970F8}'
  PROGID = 'P2ClientGate.P2DataStream.1'
  include WIN32OLE::VARIANT
  attr_reader :lastargs
  attr_reader :ole

  def initialize opts = {}
    super PROGID, opts
  end

  def method_missing(cmd, *args)
    @ole.method_missing(cmd, *args)
  end

  def keep_lastargs(return_value)
    @lastargs = WIN32OLE::ARGV
    return_value
  end

  def clsid
    CLSID
  end

  def progid
    PROGID
  end

  # property IP2TableSet TableSet
  def TableSet()
    @ole._getproperty(1, [], [])
  end

  # property BSTR StreamName
  def StreamName()
    @ole._getproperty(2, [], [])
  end

  # property BSTR DBConnString
  def DBConnString()
    @ole._getproperty(3, [], [])
  end

  # TRequestType type: property Type
  def type()
    @ole._getproperty(4, [], [])
  end

  # property TDataStreamState State
  def State()
    @ole._getproperty(5, [], [])
  end

  # property VOID TableSet
  def TableSet=(val)
    @ole._setproperty(1, [val], [VT_BYREF|VT_DISPATCH])
  end

  # property VOID StreamName
  def StreamName=(val)
    @ole._setproperty(2, [val], [VT_BSTR])
  end

  # property VOID DBConnString
  def DBConnString=(val)
    @ole._setproperty(3, [val], [VT_BSTR])
  end

  # VOID type: property Type
  def type=(val)
    @ole._setproperty(4, [val], [VT_DISPATCH])
  end

  # method VOID Open
  #   IP2Connection conn [IN]
  def Open(conn)
    @ole._invoke(6, [conn], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID Close
  def Close()
    @ole._invoke(7, [], [])
  end

  # HRESULT GetScheme
  #   OLE_HANDLE p_val [OUT]
  def GetScheme(p_val)
    keep_lastargs @ole._invoke(1610678272, [p_val], [VT_BYREF|VT_BYREF|VT_DISPATCH])
  end

  # HRESULT LinkDataBuffer
  #   IP2DataStreamEvents data_buff [IN]
  def LinkDataBuffer(data_buff)
    @ole._invoke(1610678273, [data_buff], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamStateChanged - EVENT in IP2DataStreamEvents
  #   IP2DataStream stream [IN]
  #   TDataStreamState new_state [IN]
  def StreamStateChanged(stream, new_state)
    @ole._invoke(1, [stream, new_state], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
  end

  # method VOID StreamDataInserted - EVENT in IP2DataStreamEvents
  #   IP2DataStream stream [IN]
  #   BSTR table_name [IN]
  #   IP2Record rec [IN]
  def StreamDataInserted(stream, table_name, rec)
    @ole._invoke(2, [stream, table_name, rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataUpdated - EVENT in IP2DataStreamEvents
  #   IP2DataStream stream [IN]
  #   BSTR table_name [IN]
  #   I8 id [IN]
  #   IP2Record rec [IN]
  def StreamDataUpdated(stream, table_name, id, rec)
    @ole._invoke(3, [stream, table_name, id, rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataDeleted - EVENT in IP2DataStreamEvents
  #   IP2DataStream stream [IN]
  #   BSTR table_name [IN]
  #   I8 id [IN]
  #   IP2Record rec [IN]
  def StreamDataDeleted(stream, table_name, id, rec)
    @ole._invoke(4, [stream, table_name, id, rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDatumDeleted - EVENT in IP2DataStreamEvents
  #   IP2DataStream stream [IN]
  #   BSTR table_name [IN]
  #   I8 rev [IN]
  def StreamDatumDeleted(stream, table_name, rev)
    @ole._invoke(5, [stream, table_name, rev], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8])
  end

  # method VOID StreamDBWillBeDeleted - EVENT in IP2DataStreamEvents
  #   IP2DataStream stream [IN]
  def StreamDBWillBeDeleted(stream)
    @ole._invoke(6, [stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamLifeNumChanged - EVENT in IP2DataStreamEvents
  #   IP2DataStream stream [IN]
  #   I4 life_num [IN]
  def StreamLifeNumChanged(stream, life_num)
    @ole._invoke(7, [stream, life_num], [VT_BYREF|VT_DISPATCH, VT_I4])
  end

  # method VOID StreamDataBegin - EVENT in IP2DataStreamEvents
  #   IP2DataStream stream [IN]
  def StreamDataBegin(stream)
    @ole._invoke(8, [stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataEnd - EVENT in IP2DataStreamEvents
  #   IP2DataStream stream [IN]
  def StreamDataEnd(stream)
    @ole._invoke(9, [stream], [VT_BYREF|VT_DISPATCH])
  end
end

# IP2DataStream Interface
module IP2DataStream
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # property IP2TableSet TableSet
  def TableSet()
    _getproperty(1, [], [])
  end

  # property BSTR StreamName
  def StreamName()
    _getproperty(2, [], [])
  end

  # property BSTR DBConnString
  def DBConnString()
    _getproperty(3, [], [])
  end

  # TRequestType type: property Type
  def type()
    _getproperty(4, [], [])
  end

  # property TDataStreamState State
  def State()
    _getproperty(5, [], [])
  end

  # property VOID TableSet
  def TableSet=(val)
    _setproperty(1, [val], [VT_BYREF|VT_DISPATCH])
  end

  # property VOID StreamName
  def StreamName=(val)
    _setproperty(2, [val], [VT_BSTR])
  end

  # property VOID DBConnString
  def DBConnString=(val)
    _setproperty(3, [val], [VT_BSTR])
  end

  # VOID type: property Type
  def type=(val)
    _setproperty(4, [val], [VT_DISPATCH])
  end

  # method VOID Open
  #   IP2Connection conn [IN]
  def Open(conn)
    _invoke(6, [conn], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID Close
  def Close()
    _invoke(7, [], [])
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

  # method VOID StreamStateChanged
  #   IP2DataStream stream [IN]
  #   TDataStreamState new_state [IN]
  def StreamStateChanged(stream, new_state)
    _invoke(1, [stream, new_state], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
  end

  # method VOID StreamDataInserted
  #   IP2DataStream stream [IN]
  #   BSTR table_name [IN]
  #   IP2Record rec [IN]
  def StreamDataInserted(stream, table_name, rec)
    _invoke(2, [stream, table_name, rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataUpdated
  #   IP2DataStream stream [IN]
  #   BSTR table_name [IN]
  #   I8 id [IN]
  #   IP2Record rec [IN]
  def StreamDataUpdated(stream, table_name, id, rec)
    _invoke(3, [stream, table_name, id, rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataDeleted
  #   IP2DataStream stream [IN]
  #   BSTR table_name [IN]
  #   I8 id [IN]
  #   IP2Record rec [IN]
  def StreamDataDeleted(stream, table_name, id, rec)
    _invoke(4, [stream, table_name, id, rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDatumDeleted
  #   IP2DataStream stream [IN]
  #   BSTR table_name [IN]
  #   I8 rev [IN]
  def StreamDatumDeleted(stream, table_name, rev)
    _invoke(5, [stream, table_name, rev], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8])
  end

  # method VOID StreamDBWillBeDeleted
  #   IP2DataStream stream [IN]
  def StreamDBWillBeDeleted(stream)
    _invoke(6, [stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamLifeNumChanged
  #   IP2DataStream stream [IN]
  #   I4 life_num [IN]
  def StreamLifeNumChanged(stream, life_num)
    _invoke(7, [stream, life_num], [VT_BYREF|VT_DISPATCH, VT_I4])
  end

  # method VOID StreamDataBegin
  #   IP2DataStream stream [IN]
  def StreamDataBegin(stream)
    _invoke(8, [stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataEnd
  #   IP2DataStream stream [IN]
  def StreamDataEnd(stream)
    _invoke(9, [stream], [VT_BYREF|VT_DISPATCH])
  end
end

# P2DataBuffer Class
class CP2DataBuffer < Base # P2ClientGate_P2DataBuffer_1
  CLSID = '{30E32F86-2B2A-47E4-A3B9-FDA18197E6E0}'
  PROGID = 'P2ClientGate.P2DataBuffer.1'
  include WIN32OLE::VARIANT
  attr_reader :lastargs
  attr_reader :ole

  def initialize opts = {}
    super PROGID, opts
  end

  def method_missing(cmd, *args)
    @ole.method_missing(cmd, *args)
  end

  def keep_lastargs(return_value)
    @lastargs = WIN32OLE::ARGV
    return_value
  end

  def clsid
    CLSID
  end

  def progid
    PROGID
  end

  # PTR TableRecords: property Records
  #   BSTR table_name [IN]
  def TableRecords
    @_TableRecords ||= OLEProperty.new(@ole, 4, [VT_BSTR], [VT_BSTR, VT_BYREF|VT_DISPATCH])
  end

  # method VOID AttachToStream
  #   IP2DataStream stream [IN]
  def AttachToStream(stream)
    @ole._invoke(1, [stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID DetachFromStream
  def DetachFromStream()
    @ole._invoke(2, [], [])
  end

  # method I4 CountTables
  def CountTables()
    @ole._invoke(3, [], [])
  end

  # method I4 Count
  #   BSTR table_name [IN]
  def Count(table_name)
    @ole._invoke(5, [table_name], [VT_BSTR])
  end

  # method VOID Clear
  #   BSTR table_name [IN]
  def Clear(table_name)
    @ole._invoke(6, [table_name], [VT_BSTR])
  end

  # VOID ClearAll: method Clear
  def ClearAll()
    @ole._invoke(8, [], [])
  end

  # method VOID StreamStateChanged
  #   IP2DataStream stream [IN]
  #   TDataStreamState new_state [IN]
  def StreamStateChanged(stream, new_state)
    @ole._invoke(1, [stream, new_state], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
  end

  # method VOID StreamDataInserted
  #   IP2DataStream stream [IN]
  #   BSTR table_name [IN]
  #   IP2Record rec [IN]
  def StreamDataInserted(stream, table_name, rec)
    @ole._invoke(2, [stream, table_name, rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataUpdated
  #   IP2DataStream stream [IN]
  #   BSTR table_name [IN]
  #   I8 id [IN]
  #   IP2Record rec [IN]
  def StreamDataUpdated(stream, table_name, id, rec)
    @ole._invoke(3, [stream, table_name, id, rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataDeleted
  #   IP2DataStream stream [IN]
  #   BSTR table_name [IN]
  #   I8 id [IN]
  #   IP2Record rec [IN]
  def StreamDataDeleted(stream, table_name, id, rec)
    @ole._invoke(4, [stream, table_name, id, rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDatumDeleted
  #   IP2DataStream stream [IN]
  #   BSTR table_name [IN]
  #   I8 rev [IN]
  def StreamDatumDeleted(stream, table_name, rev)
    @ole._invoke(5, [stream, table_name, rev], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8])
  end

  # method VOID StreamDBWillBeDeleted
  #   IP2DataStream stream [IN]
  def StreamDBWillBeDeleted(stream)
    @ole._invoke(6, [stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamLifeNumChanged
  #   IP2DataStream stream [IN]
  #   I4 life_num [IN]
  def StreamLifeNumChanged(stream, life_num)
    @ole._invoke(7, [stream, life_num], [VT_BYREF|VT_DISPATCH, VT_I4])
  end

  # method VOID StreamDataBegin
  #   IP2DataStream stream [IN]
  def StreamDataBegin(stream)
    @ole._invoke(8, [stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataEnd
  #   IP2DataStream stream [IN]
  def StreamDataEnd(stream)
    @ole._invoke(9, [stream], [VT_BYREF|VT_DISPATCH])
  end
end

# IP2DataBuffer Interface
module IP2DataBuffer
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # PTR TableRecords: property Records
  #   BSTR table_name [IN]
  def TableRecords
    @_TableRecords ||= OLEProperty.new(self, 4, [VT_BSTR], [VT_BSTR, VT_BYREF|VT_DISPATCH])
  end

  # method VOID AttachToStream
  #   IP2DataStream stream [IN]
  def AttachToStream(stream)
    _invoke(1, [stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID DetachFromStream
  def DetachFromStream()
    _invoke(2, [], [])
  end

  # method I4 CountTables
  def CountTables()
    _invoke(3, [], [])
  end

  # method I4 Count
  #   BSTR table_name [IN]
  def Count(table_name)
    _invoke(5, [table_name], [VT_BSTR])
  end

  # method VOID Clear
  #   BSTR table_name [IN]
  def Clear(table_name)
    _invoke(6, [table_name], [VT_BSTR])
  end

  # VOID ClearAll: method Clear
  def ClearAll()
    _invoke(8, [], [])
  end
end

# IP2Table Interface
module IP2TableRecords
  include WIN32OLE::VARIANT
  attr_reader :lastargs
end

# P2Application Class
class CP2Application < Base # P2ClientGate_P2Application_1
  CLSID = '{08A95064-05C2-4EF4-8B5D-D6211C2C9880}'
  PROGID = 'P2ClientGate.P2Application.1'
  include WIN32OLE::VARIANT
  attr_reader :lastargs
  attr_reader :ole

  def initialize opts = {}
    super PROGID, opts
  end

  def method_missing(cmd, *args)
    @ole.method_missing(cmd, *args)
  end

  def keep_lastargs(return_value)
    @lastargs = WIN32OLE::ARGV
    return_value
  end

  def clsid
    CLSID
  end

  def progid
    PROGID
  end

  # property UI4 ParserType
  def ParserType()
    @ole._getproperty(3, [], [])
  end

  # property VOID ParserType
  def ParserType=(val)
    @ole._setproperty(3, [val], [VT_UI4])
  end

  # method VOID StartUp
  #   BSTR ini_file_name [IN]
  def StartUp(ini_file_name)
    @ole._invoke(1, [ini_file_name], [VT_BSTR])
  end

  # method VOID CleanUp
  def CleanUp()
    @ole._invoke(2, [], [])
  end

  # method IP2Connection CreateP2Connection
  def CreateP2Connection()
    @ole._invoke(4, [], [])
  end

  # method IP2BLMessage CreateP2BLMessage
  def CreateP2BLMessage()
    @ole._invoke(5, [], [])
  end

  # method IP2BLMessageFactory CreateP2BLMessageFactory
  def CreateP2BLMessageFactory()
    @ole._invoke(6, [], [])
  end

  # method IP2DataBuffer CreateP2DataBuffer
  def CreateP2DataBuffer()
    @ole._invoke(7, [], [])
  end

  # method IP2DataStream CreateP2DataStream
  def CreateP2DataStream()
    @ole._invoke(8, [], [])
  end

  # method IP2TableSet CreateP2TableSet
  def CreateP2TableSet()
    @ole._invoke(9, [], [])
  end
end

# IP2Application Interface
module IP2Application
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # property UI4 ParserType
  def ParserType()
    _getproperty(3, [], [])
  end

  # property VOID ParserType
  def ParserType=(val)
    _setproperty(3, [val], [VT_UI4])
  end

  # method VOID StartUp
  #   BSTR ini_file_name [IN]
  def StartUp(ini_file_name)
    _invoke(1, [ini_file_name], [VT_BSTR])
  end

  # method VOID CleanUp
  def CleanUp()
    _invoke(2, [], [])
  end

  # method IP2Connection CreateP2Connection
  def CreateP2Connection()
    _invoke(4, [], [])
  end

  # method IP2BLMessage CreateP2BLMessage
  def CreateP2BLMessage()
    _invoke(5, [], [])
  end

  # method IP2BLMessageFactory CreateP2BLMessageFactory
  def CreateP2BLMessageFactory()
    _invoke(6, [], [])
  end

  # method IP2DataBuffer CreateP2DataBuffer
  def CreateP2DataBuffer()
    _invoke(7, [], [])
  end

  # method IP2DataStream CreateP2DataStream
  def CreateP2DataStream()
    _invoke(8, [], [])
  end

  # method IP2TableSet CreateP2TableSet
  def CreateP2TableSet()
    _invoke(9, [], [])
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

  # method VOID StreamStateChanged
  #   IP2DataStream stream [IN]
  #   TDataStreamState new_state [IN]
  def StreamStateChanged(stream, new_state)
    _invoke(1, [stream, new_state], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
  end

  # method VOID StreamDataInserted
  #   IP2DataStream stream [IN]
  #   BSTR table_name [IN]
  #   IP2Record rec [IN]
  def StreamDataInserted(stream, table_name, rec)
    _invoke(2, [stream, table_name, rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataUpdated
  #   IP2DataStream stream [IN]
  #   BSTR table_name [IN]
  #   I8 id [IN]
  #   IP2Record rec [IN]
  def StreamDataUpdated(stream, table_name, id, rec)
    _invoke(3, [stream, table_name, id, rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataDeleted
  #   IP2DataStream stream [IN]
  #   BSTR table_name [IN]
  #   I8 id [IN]
  #   IP2Record rec [IN]
  def StreamDataDeleted(stream, table_name, id, rec)
    _invoke(4, [stream, table_name, id, rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDatumDeleted
  #   IP2DataStream stream [IN]
  #   BSTR table_name [IN]
  #   I8 rev [IN]
  def StreamDatumDeleted(stream, table_name, rev)
    _invoke(5, [stream, table_name, rev], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8])
  end

  # method VOID StreamDBWillBeDeleted
  #   IP2DataStream stream [IN]
  def StreamDBWillBeDeleted(stream)
    _invoke(6, [stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamLifeNumChanged
  #   IP2DataStream stream [IN]
  #   I4 life_num [IN]
  def StreamLifeNumChanged(stream, life_num)
    _invoke(7, [stream, life_num], [VT_BYREF|VT_DISPATCH, VT_I4])
  end

  # method VOID StreamDataBegin
  #   IP2DataStream stream [IN]
  def StreamDataBegin(stream)
    _invoke(8, [stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataEnd
  #   IP2DataStream stream [IN]
  def StreamDataEnd(stream)
    _invoke(9, [stream], [VT_BYREF|VT_DISPATCH])
  end
end
