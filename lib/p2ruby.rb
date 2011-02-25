require 'version'
require 'win32ole'
require 'win32ole/property'

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

# Namespace for loading P2ClientGate constants and helper methods
module P2
  #  enum TConnectionStatus — состояние соединения/роутера. Возможны следующие значения:
  # — соединение с роутером еще не установлено.
  CS_CONNECTION_DISCONNECTED = 1
  # - соединение с роутером установлено.
  CS_CONNECTION_CONNECTED = 2
  # - нарушен протокол работы соединения, дальнейшая
  #   работа возможна только после повторной установки соединения.
  CS_CONNECTION_INVALID = 4
  # — соединение временно заблокировано функцией получения сообщения.
  CS_CONNECTION_BUSY = 8
  # — роутер запущен, но не присоединен к сети. Роутер не создает удаленных исходящих
  #   соединений, имени не имеет, принимает только локальные соединения, при этом
  #   локальные приложения могут взаимодействовать между собой через роутер.
  CS_ROUTER_DISCONNECTED = 65536
  # — роутер получил аутентификационную информацию (имя и пароль), пытается установить
  #   исходящее соединение, но ни одно исходящее соединение еще не установлено.
  CS_ROUTER_RECONNECTING = 131072
  # — роутер установил по крайней мере одно исходящее соединение, аутентификационная
  #   информация подтверждена.
  CS_ROUTER_CONNECTED = 262144
  # — по крайней мере один из сервисов отклонил аутентификационную информацию. В этом
  #   случае аутентификационная информация становится недействительной. Для продолжения
  #   работы  необходимо провести последовательный вызов методов Logout и Login.
  CS_ROUTER_LOGINFAILED = 524288
  # — за заданное количество попыток роутер не смог установить ни одного исходящего
  #   соединения, но аутентификационная информация подтверждена. Роутер больше не будет
  #   пытаться  установить исходящие соединения. Для продолжения работы
  #   необходимо провести последовательный вызов методов Logout и Login.
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

  # enum TRequestType — тип потока репликации. Тип потока определяет источник и способ
  # получения данных (снэпшот/онлайн), а также метод хранения удаленных на сервере
  # записей в локальной БД клиента. Возможны следующие значения:
  # — данные получаются из локальной БД клиента репликации в режиме снэпшот.
  RT_LOCAL = 0
  # — используются локальные данные плюс данные от сервера репликации в режиме снэпшот.
  #   После получения всех данных от сервера поток закрывается.
  RT_COMBINED_SNAPSHOT = 1
  # ?	используются локальные данные плюс данные от сервера репликации в режиме снэпшот.
  #   После получения всех данных от сервера поток переходит в режим онлайн-репликации.
  RT_COMBINED_DYNAMIC = 2
  # ? данные получаются от сервера репликации в режиме снэпшот. Используется для клиентов
  #   репликации, у которых БД не задана.
  RT_REMOTE_SNAPSHOT = 3
  # — флаг, предписывающий сразу удалять из БД клиента записи, помеченные, как удаленные.
  #   Для приложений, обращающихся к БД напрямую, этот способ хранения сильно упрощает
  #   логику работы. Этот флаг должен устанавливаться совместно с одним из
  #   флагов 0,1,2,3,8 путем двоичного сложения.
  RT_REMOVE_DELETED = 4
  # ?	поток начинает получать данные в режиме онлайн сразу. Вся фаза начальной
  #   синхронизации с сервером пропускается, поэтому в этом режиме гарантировать
  #   соответствие данных клиента и сервера нельзя. Возможное использование – получение
  #   только дополняемых данных, например, сделок, с момента открытия потока.
  RT_REMOTE_ONLINE = 8

  # enum TDataStreamState — состояние потока репликации. Возможны следующие состояния:
  # ?	0 — поток закрыт.
  DS_STATE_CLOSE = 0
  # ?	1  — поток в состоянии получения снэпшота из локальной БД клиента репликации.
  DS_STATE_LOCAL_SNAPSHOT = 1
  # ?	2 — поток в состоянии получения снэпшота от сервера репликации.
  DS_STATE_REMOTE_SNAPSHOT = 2
  # ?	3 — поток в состоянии получения онлайн-данных от сервера репликации.
  DS_STATE_ONLINE = 3
  # ?	4 — поток закрыт после получения всех требуемых данных.
  DS_STATE_CLOSE_COMPLETE = 4
  # ?	5 — поток переоткрыт и клиент будет получать все данные заново. Возможно, например,
  #       в случае изменения прав клиента или изменения номера жизни схемы БД.
  DS_STATE_REOPEN = 5
  # ?	6 (DS_STATE_ERROR) — ошибка.
  DS_STATE_ERROR = 6

# Error codes
  P2ERR_OK = P2MQ_ERRORCLASS_OK = P2ERR_COMMON_BEGIN = 0x0000
  P2MQ_ERRORCLASS_IS_USELESS = 0x0001

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
require 'p2ruby/p2class'
require 'p2ruby/application'
require 'p2ruby/connection'
require 'p2ruby/message_factory'
require 'p2ruby/message'
require 'p2ruby/data_stream'
