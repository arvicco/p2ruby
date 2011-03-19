require 'version'
require 'win32ole'
require 'win32ole/property'
require 'win_gui'
#require 'win32ole-pr'

# Namespace for loading P2ClientGate constants and helper methods
module P2
  #  enum TConnectionStatus � ��������� ����������/�������. �������� ��������� ��������:
  # � ���������� � �������� ��� �� �����������.
  CS_CONNECTION_DISCONNECTED = 1
  # - ���������� � �������� �����������.
  CS_CONNECTION_CONNECTED = 2
  # - ������� �������� ������ ����������, ����������
  #   ������ �������� ������ ����� ��������� ��������� ����������.
  CS_CONNECTION_INVALID = 4
  # � ���������� �������� ������������� �������� ��������� ���������.
  CS_CONNECTION_BUSY = 8
  # � ������ �������, �� �� ����������� � ����. ������ �� ������� ��������� ���������
  #   ����������, ����� �� �����, ��������� ������ ��������� ����������, ��� ����
  #   ��������� ���������� ����� ����������������� ����� ����� ����� ������.
  CS_ROUTER_DISCONNECTED = 65536
  # � ������ ������� ������������������ ���������� (��� � ������), �������� ����������
  #   ��������� ����������, �� �� ���� ��������� ���������� ��� �� �����������.
  CS_ROUTER_RECONNECTING = 131072
  # � ������ ��������� �� ������� ���� ���� ��������� ����������, ������������������
  #   ���������� ������������.
  CS_ROUTER_CONNECTED = 262144
  # � �� ������� ���� ���� �� �������� �������� ������������������ ����������. � ����
  #   ������ ������������������ ���������� ���������� ����������������. ��� �����������
  #   ������  ���������� �������� ���������������� ����� ������� Logout � Login.
  CS_ROUTER_LOGINFAILED = 524288
  # � �� �������� ���������� ������� ������ �� ���� ���������� �� ������ ����������
  #   ����������, �� ������������������ ���������� ������������. ������ ������ �� �����
  #   ��������  ���������� ��������� ����������. ��� ����������� ������
  #   ���������� �������� ���������������� ����� ������� Logout � Login.
  CS_ROUTER_NOCONNECT = 1048576

  CS_MESSAGES = {CS_CONNECTION_DISCONNECTED => 'Connection Disconnected',
                 CS_CONNECTION_CONNECTED => 'Connection Connected',
                 CS_CONNECTION_INVALID => 'Connection Invalid',
                 CS_CONNECTION_BUSY => 'Connection Busy',
                 CS_ROUTER_DISCONNECTED => 'Router Disconnected',
                 CS_ROUTER_RECONNECTING => 'Router Reconnecting',
                 CS_ROUTER_CONNECTED => 'Router Connected',
                 CS_ROUTER_LOGINFAILED => 'Router Login Failed',
                 CS_ROUTER_NOCONNECT => 'Router No Connect'}

  # enum TRequestType � ��� ������ ����������. ��� ������ ���������� �������� � ������
  # ��������� ������ (�������/������), � ����� ����� �������� ��������� �� �������
  # ������� � ��������� �� �������. �������� ��������� ��������:
  # � ������ ���������� �� ��������� �� ������� ���������� � ������ �������.
  RT_LOCAL = 0
  # � ������������ ��������� ������ ���� ������ �� ������� ���������� � ������ �������.
  #   ����� ��������� ���� ������ �� ������� ����� �����������.
  RT_COMBINED_SNAPSHOT = 1
  # ?	������������ ��������� ������ ���� ������ �� ������� ���������� � ������ �������.
  #   ����� ��������� ���� ������ �� ������� ����� ��������� � ����� ������-����������.
  RT_COMBINED_DYNAMIC = 2
  # ? ������ ���������� �� ������� ���������� � ������ �������. ������������ ��� ��������
  #   ����������, � ������� �� �� ������.
  RT_REMOTE_SNAPSHOT = 3
  # � ����, �������������� ����� ������� �� �� ������� ������, ����������, ��� ���������.
  #   ��� ����������, ������������ � �� ��������, ���� ������ �������� ������ ��������
  #   ������ ������. ���� ���� ������ ��������������� ��������� � ����� ��
  #   ������ 0,1,2,3,8 ����� ��������� ��������.
  RT_REMOVE_DELETED = 4
  # ?	����� �������� �������� ������ � ������ ������ �����. ��� ���� ���������
  #   ������������� � �������� ������������, ������� � ���� ������ �������������
  #   ������������ ������ ������� � ������� ������. ��������� ������������� � ���������
  #   ������ ����������� ������, ��������, ������, � ������� �������� ������.
  RT_REMOTE_ONLINE = 8

  # enum TDataStreamState � ��������� ������ ����������. �������� ��������� ���������:
  # ?	0 � ����� ������.
  DS_STATE_CLOSE = 0
  # ?	1  � ����� � ��������� ��������� �������� �� ��������� �� ������� ����������.
  DS_STATE_LOCAL_SNAPSHOT = 1
  # ?	2 � ����� � ��������� ��������� �������� �� ������� ����������.
  DS_STATE_REMOTE_SNAPSHOT = 2
  # ?	3 � ����� � ��������� ��������� ������-������ �� ������� ����������.
  DS_STATE_ONLINE = 3
  # ?	4 � ����� ������ ����� ��������� ���� ��������� ������.
  DS_STATE_CLOSE_COMPLETE = 4
  # ?	5 � ����� ���������� � ������ ����� �������� ��� ������ ������. ��������, ��������,
  #       � ������ ��������� ���� ������� ��� ��������� ������ ����� ����� ��.
  DS_STATE_REOPEN = 5
  # ?	6 (DS_STATE_ERROR) � ������.
  DS_STATE_ERROR = 6

  DS_MESSAGES = {
      DS_STATE_CLOSE => "Data Stream Closed",
      DS_STATE_LOCAL_SNAPSHOT => "Data Stream in Local Snapshot",
      DS_STATE_REMOTE_SNAPSHOT => "Data Stream in Remote Snapshot",
      DS_STATE_ONLINE => "Data Stream Online",
      DS_STATE_CLOSE_COMPLETE => "Data Stream Completed and Closed",
      DS_STATE_REOPEN => "Data Stream Reopen",
      DS_STATE_ERROR => "Data Stream Error"}

# Error codes
  P2ERR_OK = P2MQ_ERRORCLASS_OK = P2ERR_COMMON_BEGIN = 0x0000
  P2MQ_ERRORCLASS_IS_USELESS = 0x0001

  P2ERR_INI_BEGIN = 0x4000
  P2ERR_INI_ALREADY_STARTED = P2ERR_INI_BEGIN
  P2ERR_INI_FILE_NOT_FOUND = P2ERR_INI_BEGIN + 4

  # Extracts P2 error code from WIN32OLERuntimeError HRESULT error code
  def self.p2_error exception
    match = exception.message.match /HRESULT error code:0x....(\d{4})/
    code = match[1].to_i(16) if match
  end

  # Extracts P2 error code from WIN32OLERuntimeError HRESULT error code
  def self.com_error exception
    match = exception.message.match /HRESULT error code:0x(\d{4})/
    code = match[1].to_i(16) if match
  end

  # Any P2-specific Error
  class Error < StandardError
  end

  # Allows extended manipulation of all P2-specific exceptions (Error aspect)
  def error *args
    if args.first.is_a? Exception
      raise args.first
    else
      raise P2::Error.new *args
    end
  end

  # Mainly to enable P2#error both in instance and class methods
  def self.included(host)
    host.extend self
  end
end

# Aliases for P2
P2Ruby = P2
P2ClientGate = P2

require 'extension'
require 'p2ruby/router'
require 'p2ruby/library'
require 'p2ruby/base'
require 'p2ruby/application'
require 'p2ruby/connection'
require 'p2ruby/message_factory'
require 'p2ruby/message'
require 'p2ruby/data_stream'
require 'p2ruby/record'
require 'p2ruby/table_set'
