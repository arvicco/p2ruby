require 'win32ole'
require 'win32ole/property'

# P2Connection Class
class CP2Connection < P2Class # P2ClientGate_P2Connection_1
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
  def AppName=()
    @ole._setproperty(2, [], [VT_BSTR])
  end

  # property VOID Host
  def Host=()
    @ole._setproperty(4, [], [VT_BSTR])
  end

  # property VOID Port
  def Port=()
    @ole._setproperty(5, [], [VT_UI4])
  end

  # property VOID Password
  def Password=()
    @ole._setproperty(6, [], [VT_VARIANT])
  end

  # property VOID Timeout
  def Timeout=()
    @ole._setproperty(7, [], [VT_UI4])
  end

  # property VOID LoginStr
  def LoginStr=()
    @ole._setproperty(8, [], [VT_BSTR])
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
  #   UI4 _cookie [OUT]
  #   UI4 _pollTimeout [IN]
  def ProcessMessage(_cookie, _pollTimeout)
    keep_lastargs @ole._invoke(13, [_cookie, _pollTimeout], [VT_BYREF|VT_UI4, VT_UI4])
  end

  # method UI4 RegisterReceiver
  #   IP2MessageReceiver _newReceiver [IN]
  def RegisterReceiver(_newReceiver)
    @ole._invoke(14, [_newReceiver], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID UnRegisterReceiver
  #   UI4 _cookie [IN]
  def UnRegisterReceiver(_cookie)
    @ole._invoke(15, [_cookie], [VT_UI4])
  end

  # method BSTR ResolveService
  #   BSTR _service [IN]
  def ResolveService(_service)
    @ole._invoke(16, [_service], [VT_BSTR])
  end

  # method UI4 ProcessMessage2
  #   UI4 _pollTimeout [IN]
  def ProcessMessage2(_pollTimeout)
    @ole._invoke(17, [_pollTimeout], [VT_UI4])
  end

  # method UI4 Connect2
  #   BSTR _connStr [IN]
  def Connect2(_connStr)
    @ole._invoke(18, [_connStr], [VT_BSTR])
  end

  # method UI4 ProcessMessage3
  #   UI4 _pollTimeout [IN]
  def ProcessMessage3(_pollTimeout)
    @ole._invoke(19, [_pollTimeout], [VT_UI4])
  end

  # HRESULT GetConn
  #   OLE_HANDLE _pVal [OUT]
  def GetConn(_pVal)
    keep_lastargs @ole._invoke(1610678272, [_pVal], [VT_BYREF|VT_BYREF|VT_DISPATCH])
  end

  # HRESULT GetConnPtr
  #   OLE_HANDLE _pVal [OUT]
  def GetConnPtr(_pVal)
    keep_lastargs @ole._invoke(1610678273, [_pVal], [VT_BYREF|VT_BYREF|VT_DISPATCH])
  end

  # method VOID ConnectionStatusChanged - EVENT in IP2ConnectionEvent
  #   IP2Connection _conn [IN]
  #   TConnectionStatus _newStatus [IN]
  def ConnectionStatusChanged(_conn, _newStatus)
    @ole._invoke(1, [_conn, _newStatus], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
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
  def AppName=()
    _setproperty(2, [], [VT_BSTR])
  end

  # property VOID Host
  def Host=()
    _setproperty(4, [], [VT_BSTR])
  end

  # property VOID Port
  def Port=()
    _setproperty(5, [], [VT_UI4])
  end

  # property VOID Password
  def Password=()
    _setproperty(6, [], [VT_VARIANT])
  end

  # property VOID Timeout
  def Timeout=()
    _setproperty(7, [], [VT_UI4])
  end

  # property VOID LoginStr
  def LoginStr=()
    _setproperty(8, [], [VT_BSTR])
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
  #   UI4 _cookie [OUT]
  #   UI4 _pollTimeout [IN]
  def ProcessMessage(_cookie, _pollTimeout)
    keep_lastargs _invoke(13, [_cookie, _pollTimeout], [VT_BYREF|VT_UI4, VT_UI4])
  end

  # method UI4 RegisterReceiver
  #   IP2MessageReceiver _newReceiver [IN]
  def RegisterReceiver(_newReceiver)
    _invoke(14, [_newReceiver], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID UnRegisterReceiver
  #   UI4 _cookie [IN]
  def UnRegisterReceiver(_cookie)
    _invoke(15, [_cookie], [VT_UI4])
  end

  # method BSTR ResolveService
  #   BSTR _service [IN]
  def ResolveService(_service)
    _invoke(16, [_service], [VT_BSTR])
  end

  # method UI4 ProcessMessage2
  #   UI4 _pollTimeout [IN]
  def ProcessMessage2(_pollTimeout)
    _invoke(17, [_pollTimeout], [VT_UI4])
  end

  # method UI4 Connect2
  #   BSTR _connStr [IN]
  def Connect2(_connStr)
    _invoke(18, [_connStr], [VT_BSTR])
  end

  # method UI4 ProcessMessage3
  #   UI4 _pollTimeout [IN]
  def ProcessMessage3(_pollTimeout)
    _invoke(19, [_pollTimeout], [VT_UI4])
  end
end

# IP2MessageReceiver Dispinterface
module IP2MessageReceiver
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # method VOID GetFilter
  #   VARIANT _from [OUT]
  #   VARIANT _type [OUT]
  #   VARIANT _category [OUT]
  def GetFilter(_from, _type, _category)
    keep_lastargs _invoke(1, [_from, _type, _category], [VT_BYREF|VT_VARIANT, VT_BYREF|VT_VARIANT, VT_BYREF|VT_VARIANT])
  end

  # method VOID PutMessage
  #   DISPATCH _pMsg [IN]
  def PutMessage(_pMsg)
    _invoke(2, [_pMsg], [VT_DISPATCH])
  end
end

# IP2ConnectionEvent Interface
module IP2ConnectionEvent
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # method VOID ConnectionStatusChanged
  #   IP2Connection _conn [IN]
  #   TConnectionStatus _newStatus [IN]
  def ConnectionStatusChanged(_conn, _newStatus)
    _invoke(1, [_conn, _newStatus], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
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
  #   IP2BLMessage _reply [IN]
  #   UI4 _errCode [IN]
  def DeliveryEvent(_reply, _errCode)
    _invoke(1, [_reply, _errCode], [VT_BYREF|VT_DISPATCH, VT_UI4])
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
  def DestAddr=()
    _setproperty(4, [], [VT_BSTR])
  end

  # property VARIANT Field
  #   BSTR _Name [IN]
  def Field
    @_Field ||= OLEProperty.new(self, 5, [VT_BSTR], [VT_BSTR, VT_VARIANT])
  end

  # I8 FieldAsLONGLONG: property FieldAsULONGLONG
  #   BSTR _Name [IN]
  def FieldAsLONGLONG
    @_FieldAsLONGLONG ||= OLEProperty.new(self, 10, [VT_BSTR], [VT_BSTR, VT_I8])
  end

  # method IP2BLMessage Send
  #   IP2Connection _conn [IN]
  #   UI4 _Timeout [IN]
  def Send(_conn, _Timeout)
    _invoke(6, [_conn, _Timeout], [VT_BYREF|VT_DISPATCH, VT_UI4])
  end

  # method VOID Post
  #   IP2Connection _conn [IN]
  def Post(_conn)
    _invoke(7, [_conn], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID SendAsync
  #   IP2Connection _conn [IN]
  #   UI4 _Timeout [IN]
  #   DISPATCH _event [IN]
  def SendAsync(_conn, _Timeout, _event)
    _invoke(8, [_conn, _Timeout, _event], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH])
  end

  # method VOID SendAsync2
  #   IP2Connection _conn [IN]
  #   UI4 _Timeout [IN]
  #   DISPATCH _event [IN]
  #   I8 _eventParam [IN]
  def SendAsync2(_conn, _Timeout, _event, _eventParam)
    _invoke(9, [_conn, _Timeout, _event, _eventParam], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH, VT_I8])
  end
end

# IP2AsyncSendEvent2 Interface
module IP2AsyncSendEvent2
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # HRESULT SendAsync2Reply: method AsyncSendReply
  #   IP2BLMessage _reply [IN]
  #   UI4 _errCode [IN]
  #   I8 _eventParam [IN]
  def SendAsync2Reply(_reply, _errCode, _eventParam)
    _invoke(1, [_reply, _errCode, _eventParam], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_I8])
  end
end

# P2BLMessage Class
class CP2BLMessage < P2Class # P2ClientGate_P2BLMessage_1
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
  def DestAddr=()
    @ole._setproperty(4, [], [VT_BSTR])
  end

  # property VARIANT Field
  #   BSTR _Name [IN]
  def Field
    @_Field ||= OLEProperty.new(@ole, 5, [VT_BSTR], [VT_BSTR, VT_VARIANT])
  end

  # I8 FieldAsLONGLONG: property FieldAsULONGLONG
  #   BSTR _Name [IN]
  def FieldAsLONGLONG
    @_FieldAsLONGLONG ||= OLEProperty.new(@ole, 10, [VT_BSTR], [VT_BSTR, VT_I8])
  end

  # method IP2BLMessage Send
  #   IP2Connection _conn [IN]
  #   UI4 _Timeout [IN]
  def Send(_conn, _Timeout)
    @ole._invoke(6, [_conn, _Timeout], [VT_BYREF|VT_DISPATCH, VT_UI4])
  end

  # method VOID Post
  #   IP2Connection _conn [IN]
  def Post(_conn)
    @ole._invoke(7, [_conn], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID SendAsync
  #   IP2Connection _conn [IN]
  #   UI4 _Timeout [IN]
  #   DISPATCH _event [IN]
  def SendAsync(_conn, _Timeout, _event)
    @ole._invoke(8, [_conn, _Timeout, _event], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH])
  end

  # method VOID SendAsync2
  #   IP2Connection _conn [IN]
  #   UI4 _Timeout [IN]
  #   DISPATCH _event [IN]
  #   I8 _eventParam [IN]
  def SendAsync2(_conn, _Timeout, _event, _eventParam)
    @ole._invoke(9, [_conn, _Timeout, _event, _eventParam], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH, VT_I8])
  end
end

# P2BLMessageFactory Class
class CP2BLMessageFactory < P2Class # P2ClientGate_P2BLMessageFactory_1
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
  #   BSTR _structFile [IN]
  #   BSTR _signFile [IN]
  def Init(_structFile, _signFile)
    @ole._invoke(1, [_structFile, _signFile], [VT_BSTR, VT_BSTR])
  end

  # method IP2BLMessage CreateMessageByName
  #   BSTR _msgName [IN]
  def CreateMessageByName(_msgName)
    @ole._invoke(2, [_msgName], [VT_BSTR])
  end

  # method IP2BLMessage CreateMessageById
  #   UI4 _msgId [IN]
  def CreateMessageById(_msgId)
    @ole._invoke(3, [_msgId], [VT_UI4])
  end
end

# IP2BLMessageFactory Interface
module IP2BLMessageFactory
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # method VOID Init
  #   BSTR _structFile [IN]
  #   BSTR _signFile [IN]
  def Init(_structFile, _signFile)
    _invoke(1, [_structFile, _signFile], [VT_BSTR, VT_BSTR])
  end

  # method IP2BLMessage CreateMessageByName
  #   BSTR _msgName [IN]
  def CreateMessageByName(_msgName)
    _invoke(2, [_msgName], [VT_BSTR])
  end

  # method IP2BLMessage CreateMessageById
  #   UI4 _msgId [IN]
  def CreateMessageById(_msgId)
    _invoke(3, [_msgId], [VT_UI4])
  end
end

# P2TableSet Class
class CP2TableSet < P2Class # P2ClientGate_P2TableSet_1
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
  def LifeNum=()
    @ole._setproperty(11, [], [VT_I4])
  end

  # property BSTR FieldList
  #   BSTR _tableName [IN]
  def FieldList
    @_FieldList ||= OLEProperty.new(@ole, 4, [VT_BSTR], [VT_BSTR, VT_BSTR])
  end

  # I8 rev: property Rev
  #   BSTR _tableName [IN]
  def rev
    @_rev ||= OLEProperty.new(@ole, 5, [VT_BSTR], [VT_BSTR, VT_I8])
  end

  # property BSTR FieldTypes
  #   BSTR _tableName [IN]
  def FieldTypes
    @_FieldTypes ||= OLEProperty.new(@ole, 9, [VT_BSTR], [VT_BSTR, VT_BSTR])
  end

  # method VOID InitFromIni
  #   BSTR _structFile [IN]
  #   BSTR _signFile [IN]
  def InitFromIni(_structFile, _signFile)
    @ole._invoke(1, [_structFile, _signFile], [VT_BSTR, VT_BSTR])
  end

  # method VOID InitFromDB
  #   BSTR _connectString [IN]
  #   BSTR _signFile [IN]
  def InitFromDB(_connectString, _signFile)
    @ole._invoke(2, [_connectString, _signFile], [VT_BSTR, VT_BSTR])
  end

  # method VOID AddTable
  #   BSTR _tableName [IN]
  #   BSTR _fieldlList [IN]
  #   UI8 _rev [IN]
  def AddTable(_tableName, _fieldlList, _rev)
    @ole._invoke(3, [_tableName, _fieldlList, _rev], [VT_BSTR, VT_BSTR, VT_UI8])
  end

  # method VOID DeleteTable
  #   BSTR _tableName [IN]
  def DeleteTable(_tableName)
    @ole._invoke(6, [_tableName], [VT_BSTR])
  end

  # method VOID InitFromIni2
  #   BSTR _iniFileName [IN]
  #   BSTR _schemeName [IN]
  def InitFromIni2(_iniFileName, _schemeName)
    @ole._invoke(10, [_iniFileName, _schemeName], [VT_BSTR, VT_BSTR])
  end

  # method VOID SetLifeNumToIni
  #   BSTR _iniFileName [IN]
  def SetLifeNumToIni(_iniFileName)
    @ole._invoke(12, [_iniFileName], [VT_BSTR])
  end

  # HRESULT GetScheme
  #   OLE_HANDLE _pVal [OUT]
  def GetScheme(_pVal)
    keep_lastargs @ole._invoke(1610678272, [_pVal], [VT_BYREF|VT_BYREF|VT_DISPATCH])
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
  def LifeNum=()
    _setproperty(11, [], [VT_I4])
  end

  # property BSTR FieldList
  #   BSTR _tableName [IN]
  def FieldList
    @_FieldList ||= OLEProperty.new(self, 4, [VT_BSTR], [VT_BSTR, VT_BSTR])
  end

  # I8 rev: property Rev
  #   BSTR _tableName [IN]
  def rev
    @_rev ||= OLEProperty.new(self, 5, [VT_BSTR], [VT_BSTR, VT_I8])
  end

  # property BSTR FieldTypes
  #   BSTR _tableName [IN]
  def FieldTypes
    @_FieldTypes ||= OLEProperty.new(self, 9, [VT_BSTR], [VT_BSTR, VT_BSTR])
  end

  # method VOID InitFromIni
  #   BSTR _structFile [IN]
  #   BSTR _signFile [IN]
  def InitFromIni(_structFile, _signFile)
    _invoke(1, [_structFile, _signFile], [VT_BSTR, VT_BSTR])
  end

  # method VOID InitFromDB
  #   BSTR _connectString [IN]
  #   BSTR _signFile [IN]
  def InitFromDB(_connectString, _signFile)
    _invoke(2, [_connectString, _signFile], [VT_BSTR, VT_BSTR])
  end

  # method VOID AddTable
  #   BSTR _tableName [IN]
  #   BSTR _fieldlList [IN]
  #   UI8 _rev [IN]
  def AddTable(_tableName, _fieldlList, _rev)
    _invoke(3, [_tableName, _fieldlList, _rev], [VT_BSTR, VT_BSTR, VT_UI8])
  end

  # method VOID DeleteTable
  #   BSTR _tableName [IN]
  def DeleteTable(_tableName)
    _invoke(6, [_tableName], [VT_BSTR])
  end

  # method VOID InitFromIni2
  #   BSTR _iniFileName [IN]
  #   BSTR _schemeName [IN]
  def InitFromIni2(_iniFileName, _schemeName)
    _invoke(10, [_iniFileName, _schemeName], [VT_BSTR, VT_BSTR])
  end

  # method VOID SetLifeNumToIni
  #   BSTR _iniFileName [IN]
  def SetLifeNumToIni(_iniFileName)
    _invoke(12, [_iniFileName], [VT_BSTR])
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
  #   BSTR _fieldName [IN]
  def GetValAsString(_fieldName)
    _invoke(2, [_fieldName], [VT_BSTR])
  end

  # method BSTR GetValAsStringByIndex
  #   UI4 _fieldIndex [IN]
  def GetValAsStringByIndex(_fieldIndex)
    _invoke(3, [_fieldIndex], [VT_UI4])
  end

  # method I4 GetValAsLong
  #   BSTR _fieldName [IN]
  def GetValAsLong(_fieldName)
    _invoke(4, [_fieldName], [VT_BSTR])
  end

  # method I4 GetValAsLongByIndex
  #   UI4 _fieldIndex [IN]
  def GetValAsLongByIndex(_fieldIndex)
    _invoke(5, [_fieldIndex], [VT_UI4])
  end

  # method I2 GetValAsShort
  #   BSTR _fieldName [IN]
  def GetValAsShort(_fieldName)
    _invoke(6, [_fieldName], [VT_BSTR])
  end

  # method I2 GetValAsShortByIndex
  #   UI4 _fieldIndex [IN]
  def GetValAsShortByIndex(_fieldIndex)
    _invoke(7, [_fieldIndex], [VT_UI4])
  end

  # method VARIANT GetValAsVariant
  #   BSTR _fieldName [IN]
  def GetValAsVariant(_fieldName)
    _invoke(8, [_fieldName], [VT_BSTR])
  end

  # method VARIANT GetValAsVariantByIndex
  #   UI4 _fieldIndex [IN]
  def GetValAsVariantByIndex(_fieldIndex)
    _invoke(9, [_fieldIndex], [VT_UI4])
  end

  # HRESULT GetRec
  #   OLE_HANDLE _pVal [OUT]
  def GetRec(_pVal)
    keep_lastargs _invoke(1610678272, [_pVal], [VT_BYREF|VT_BYREF|VT_DISPATCH])
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
  #   BSTR _fieldName [IN]
  def GetValAsString(_fieldName)
    _invoke(2, [_fieldName], [VT_BSTR])
  end

  # method BSTR GetValAsStringByIndex
  #   UI4 _fieldIndex [IN]
  def GetValAsStringByIndex(_fieldIndex)
    _invoke(3, [_fieldIndex], [VT_UI4])
  end

  # method I4 GetValAsLong
  #   BSTR _fieldName [IN]
  def GetValAsLong(_fieldName)
    _invoke(4, [_fieldName], [VT_BSTR])
  end

  # method I4 GetValAsLongByIndex
  #   UI4 _fieldIndex [IN]
  def GetValAsLongByIndex(_fieldIndex)
    _invoke(5, [_fieldIndex], [VT_UI4])
  end

  # method I2 GetValAsShort
  #   BSTR _fieldName [IN]
  def GetValAsShort(_fieldName)
    _invoke(6, [_fieldName], [VT_BSTR])
  end

  # method I2 GetValAsShortByIndex
  #   UI4 _fieldIndex [IN]
  def GetValAsShortByIndex(_fieldIndex)
    _invoke(7, [_fieldIndex], [VT_UI4])
  end

  # method VARIANT GetValAsVariant
  #   BSTR _fieldName [IN]
  def GetValAsVariant(_fieldName)
    _invoke(8, [_fieldName], [VT_BSTR])
  end

  # method VARIANT GetValAsVariantByIndex
  #   UI4 _fieldIndex [IN]
  def GetValAsVariantByIndex(_fieldIndex)
    _invoke(9, [_fieldIndex], [VT_UI4])
  end
end

# P2DataStream Class
class CP2DataStream < P2Class # P2ClientGate_P2DataStream_1
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
  def TableSet=()
    @ole._setproperty(1, [], [VT_BYREF|VT_DISPATCH])
  end

  # property VOID StreamName
  def StreamName=()
    @ole._setproperty(2, [], [VT_BSTR])
  end

  # property VOID DBConnString
  def DBConnString=()
    @ole._setproperty(3, [], [VT_BSTR])
  end

  # VOID type: property Type
  def type=()
    @ole._setproperty(4, [], [VT_DISPATCH])
  end

  # method VOID Open
  #   IP2Connection _conn [IN]
  def Open(_conn)
    @ole._invoke(6, [_conn], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID Close
  def Close()
    @ole._invoke(7, [], [])
  end

  # HRESULT GetScheme
  #   OLE_HANDLE _pVal [OUT]
  def GetScheme(_pVal)
    keep_lastargs @ole._invoke(1610678272, [_pVal], [VT_BYREF|VT_BYREF|VT_DISPATCH])
  end

  # HRESULT LinkDataBuffer
  #   IP2DataStreamEvents _dataBuff [IN]
  def LinkDataBuffer(_dataBuff)
    @ole._invoke(1610678273, [_dataBuff], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamStateChanged - EVENT in IP2DataStreamEvents
  #   IP2DataStream _stream [IN]
  #   TDataStreamState _newState [IN]
  def StreamStateChanged(_stream, _newState)
    @ole._invoke(1, [_stream, _newState], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
  end

  # method VOID StreamDataInserted - EVENT in IP2DataStreamEvents
  #   IP2DataStream _stream [IN]
  #   BSTR _tableName [IN]
  #   IP2Record _rec [IN]
  def StreamDataInserted(_stream, _tableName, _rec)
    @ole._invoke(2, [_stream, _tableName, _rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataUpdated - EVENT in IP2DataStreamEvents
  #   IP2DataStream _stream [IN]
  #   BSTR _tableName [IN]
  #   I8 _Id [IN]
  #   IP2Record _rec [IN]
  def StreamDataUpdated(_stream, _tableName, _Id, _rec)
    @ole._invoke(3, [_stream, _tableName, _Id, _rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataDeleted - EVENT in IP2DataStreamEvents
  #   IP2DataStream _stream [IN]
  #   BSTR _tableName [IN]
  #   I8 _Id [IN]
  #   IP2Record _rec [IN]
  def StreamDataDeleted(_stream, _tableName, _Id, _rec)
    @ole._invoke(4, [_stream, _tableName, _Id, _rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDatumDeleted - EVENT in IP2DataStreamEvents
  #   IP2DataStream _stream [IN]
  #   BSTR _tableName [IN]
  #   I8 _rev [IN]
  def StreamDatumDeleted(_stream, _tableName, _rev)
    @ole._invoke(5, [_stream, _tableName, _rev], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8])
  end

  # method VOID StreamDBWillBeDeleted - EVENT in IP2DataStreamEvents
  #   IP2DataStream _stream [IN]
  def StreamDBWillBeDeleted(_stream)
    @ole._invoke(6, [_stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamLifeNumChanged - EVENT in IP2DataStreamEvents
  #   IP2DataStream _stream [IN]
  #   I4 _LifeNum [IN]
  def StreamLifeNumChanged(_stream, _LifeNum)
    @ole._invoke(7, [_stream, _LifeNum], [VT_BYREF|VT_DISPATCH, VT_I4])
  end

  # method VOID StreamDataBegin - EVENT in IP2DataStreamEvents
  #   IP2DataStream _stream [IN]
  def StreamDataBegin(_stream)
    @ole._invoke(8, [_stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataEnd - EVENT in IP2DataStreamEvents
  #   IP2DataStream _stream [IN]
  def StreamDataEnd(_stream)
    @ole._invoke(9, [_stream], [VT_BYREF|VT_DISPATCH])
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
  def TableSet=()
    _setproperty(1, [], [VT_BYREF|VT_DISPATCH])
  end

  # property VOID StreamName
  def StreamName=()
    _setproperty(2, [], [VT_BSTR])
  end

  # property VOID DBConnString
  def DBConnString=()
    _setproperty(3, [], [VT_BSTR])
  end

  # VOID type: property Type
  def type=()
    _setproperty(4, [], [VT_DISPATCH])
  end

  # method VOID Open
  #   IP2Connection _conn [IN]
  def Open(_conn)
    _invoke(6, [_conn], [VT_BYREF|VT_DISPATCH])
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
  #   IP2DataStream _stream [IN]
  #   TDataStreamState _newState [IN]
  def StreamStateChanged(_stream, _newState)
    _invoke(1, [_stream, _newState], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
  end

  # method VOID StreamDataInserted
  #   IP2DataStream _stream [IN]
  #   BSTR _tableName [IN]
  #   IP2Record _rec [IN]
  def StreamDataInserted(_stream, _tableName, _rec)
    _invoke(2, [_stream, _tableName, _rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataUpdated
  #   IP2DataStream _stream [IN]
  #   BSTR _tableName [IN]
  #   I8 _Id [IN]
  #   IP2Record _rec [IN]
  def StreamDataUpdated(_stream, _tableName, _Id, _rec)
    _invoke(3, [_stream, _tableName, _Id, _rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataDeleted
  #   IP2DataStream _stream [IN]
  #   BSTR _tableName [IN]
  #   I8 _Id [IN]
  #   IP2Record _rec [IN]
  def StreamDataDeleted(_stream, _tableName, _Id, _rec)
    _invoke(4, [_stream, _tableName, _Id, _rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDatumDeleted
  #   IP2DataStream _stream [IN]
  #   BSTR _tableName [IN]
  #   I8 _rev [IN]
  def StreamDatumDeleted(_stream, _tableName, _rev)
    _invoke(5, [_stream, _tableName, _rev], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8])
  end

  # method VOID StreamDBWillBeDeleted
  #   IP2DataStream _stream [IN]
  def StreamDBWillBeDeleted(_stream)
    _invoke(6, [_stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamLifeNumChanged
  #   IP2DataStream _stream [IN]
  #   I4 _LifeNum [IN]
  def StreamLifeNumChanged(_stream, _LifeNum)
    _invoke(7, [_stream, _LifeNum], [VT_BYREF|VT_DISPATCH, VT_I4])
  end

  # method VOID StreamDataBegin
  #   IP2DataStream _stream [IN]
  def StreamDataBegin(_stream)
    _invoke(8, [_stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataEnd
  #   IP2DataStream _stream [IN]
  def StreamDataEnd(_stream)
    _invoke(9, [_stream], [VT_BYREF|VT_DISPATCH])
  end
end

# P2DataBuffer Class
class CP2DataBuffer < P2Class # P2ClientGate_P2DataBuffer_1
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
  #   BSTR _tableName [IN]
  def TableRecords
    @_TableRecords ||= OLEProperty.new(@ole, 4, [VT_BSTR], [VT_BSTR, VT_BYREF|VT_DISPATCH])
  end

  # method VOID AttachToStream
  #   IP2DataStream _stream [IN]
  def AttachToStream(_stream)
    @ole._invoke(1, [_stream], [VT_BYREF|VT_DISPATCH])
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
  #   BSTR _tableName [IN]
  def Count(_tableName)
    @ole._invoke(5, [_tableName], [VT_BSTR])
  end

  # method VOID Clear
  #   BSTR _tableName [IN]
  def Clear(_tableName)
    @ole._invoke(6, [_tableName], [VT_BSTR])
  end

  # VOID ClearAll: method Clear
  def ClearAll()
    @ole._invoke(8, [], [])
  end

  # method VOID StreamStateChanged
  #   IP2DataStream _stream [IN]
  #   TDataStreamState _newState [IN]
  def StreamStateChanged(_stream, _newState)
    @ole._invoke(1, [_stream, _newState], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
  end

  # method VOID StreamDataInserted
  #   IP2DataStream _stream [IN]
  #   BSTR _tableName [IN]
  #   IP2Record _rec [IN]
  def StreamDataInserted(_stream, _tableName, _rec)
    @ole._invoke(2, [_stream, _tableName, _rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataUpdated
  #   IP2DataStream _stream [IN]
  #   BSTR _tableName [IN]
  #   I8 _Id [IN]
  #   IP2Record _rec [IN]
  def StreamDataUpdated(_stream, _tableName, _Id, _rec)
    @ole._invoke(3, [_stream, _tableName, _Id, _rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataDeleted
  #   IP2DataStream _stream [IN]
  #   BSTR _tableName [IN]
  #   I8 _Id [IN]
  #   IP2Record _rec [IN]
  def StreamDataDeleted(_stream, _tableName, _Id, _rec)
    @ole._invoke(4, [_stream, _tableName, _Id, _rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDatumDeleted
  #   IP2DataStream _stream [IN]
  #   BSTR _tableName [IN]
  #   I8 _rev [IN]
  def StreamDatumDeleted(_stream, _tableName, _rev)
    @ole._invoke(5, [_stream, _tableName, _rev], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8])
  end

  # method VOID StreamDBWillBeDeleted
  #   IP2DataStream _stream [IN]
  def StreamDBWillBeDeleted(_stream)
    @ole._invoke(6, [_stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamLifeNumChanged
  #   IP2DataStream _stream [IN]
  #   I4 _LifeNum [IN]
  def StreamLifeNumChanged(_stream, _LifeNum)
    @ole._invoke(7, [_stream, _LifeNum], [VT_BYREF|VT_DISPATCH, VT_I4])
  end

  # method VOID StreamDataBegin
  #   IP2DataStream _stream [IN]
  def StreamDataBegin(_stream)
    @ole._invoke(8, [_stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataEnd
  #   IP2DataStream _stream [IN]
  def StreamDataEnd(_stream)
    @ole._invoke(9, [_stream], [VT_BYREF|VT_DISPATCH])
  end
end

# IP2DataBuffer Interface
module IP2DataBuffer
  include WIN32OLE::VARIANT
  attr_reader :lastargs

  # PTR TableRecords: property Records
  #   BSTR _tableName [IN]
  def TableRecords
    @_TableRecords ||= OLEProperty.new(self, 4, [VT_BSTR], [VT_BSTR, VT_BYREF|VT_DISPATCH])
  end

  # method VOID AttachToStream
  #   IP2DataStream _stream [IN]
  def AttachToStream(_stream)
    _invoke(1, [_stream], [VT_BYREF|VT_DISPATCH])
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
  #   BSTR _tableName [IN]
  def Count(_tableName)
    _invoke(5, [_tableName], [VT_BSTR])
  end

  # method VOID Clear
  #   BSTR _tableName [IN]
  def Clear(_tableName)
    _invoke(6, [_tableName], [VT_BSTR])
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
class CP2Application < P2Class # P2ClientGate_P2Application_1
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
  def ParserType=()
    @ole._setproperty(3, [], [VT_UI4])
  end

  # method VOID StartUp
  #   BSTR _iniFileName [IN]
  def StartUp(_iniFileName)
    @ole._invoke(1, [_iniFileName], [VT_BSTR])
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
  def ParserType=()
    _setproperty(3, [], [VT_UI4])
  end

  # method VOID StartUp
  #   BSTR _iniFileName [IN]
  def StartUp(_iniFileName)
    _invoke(1, [_iniFileName], [VT_BSTR])
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
  #   IP2DataStream _stream [IN]
  #   TDataStreamState _newState [IN]
  def StreamStateChanged(_stream, _newState)
    _invoke(1, [_stream, _newState], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
  end

  # method VOID StreamDataInserted
  #   IP2DataStream _stream [IN]
  #   BSTR _tableName [IN]
  #   IP2Record _rec [IN]
  def StreamDataInserted(_stream, _tableName, _rec)
    _invoke(2, [_stream, _tableName, _rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataUpdated
  #   IP2DataStream _stream [IN]
  #   BSTR _tableName [IN]
  #   I8 _Id [IN]
  #   IP2Record _rec [IN]
  def StreamDataUpdated(_stream, _tableName, _Id, _rec)
    _invoke(3, [_stream, _tableName, _Id, _rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataDeleted
  #   IP2DataStream _stream [IN]
  #   BSTR _tableName [IN]
  #   I8 _Id [IN]
  #   IP2Record _rec [IN]
  def StreamDataDeleted(_stream, _tableName, _Id, _rec)
    _invoke(4, [_stream, _tableName, _Id, _rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDatumDeleted
  #   IP2DataStream _stream [IN]
  #   BSTR _tableName [IN]
  #   I8 _rev [IN]
  def StreamDatumDeleted(_stream, _tableName, _rev)
    _invoke(5, [_stream, _tableName, _rev], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8])
  end

  # method VOID StreamDBWillBeDeleted
  #   IP2DataStream _stream [IN]
  def StreamDBWillBeDeleted(_stream)
    _invoke(6, [_stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamLifeNumChanged
  #   IP2DataStream _stream [IN]
  #   I4 _LifeNum [IN]
  def StreamLifeNumChanged(_stream, _LifeNum)
    _invoke(7, [_stream, _LifeNum], [VT_BYREF|VT_DISPATCH, VT_I4])
  end

  # method VOID StreamDataBegin
  #   IP2DataStream _stream [IN]
  def StreamDataBegin(_stream)
    _invoke(8, [_stream], [VT_BYREF|VT_DISPATCH])
  end

  # method VOID StreamDataEnd
  #   IP2DataStream _stream [IN]
  def StreamDataEnd(_stream)
    _invoke(9, [_stream], [VT_BYREF|VT_DISPATCH])
  end
end
