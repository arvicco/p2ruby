require 'spec_helper'

describe P2 do
  include P2

  it 'has P2ClientGate constants pre-defined' do
    CS_CONNECTION_DISCONNECTED.should == 1
    CS_CONNECTION_CONNECTED.should == 2
    CS_CONNECTION_INVALID.should == 4
    CS_CONNECTION_BUSY.should == 8
    CS_ROUTER_DISCONNECTED.should == 65536
    CS_ROUTER_RECONNECTING.should == 131072
    CS_ROUTER_CONNECTED.should == 262144
    CS_ROUTER_LOGINFAILED.should == 524288
    CS_ROUTER_NOCONNECT.should == 1048576

    # module TRequestType
    RT_LOCAL.should == 0
    RT_COMBINED_SNAPSHOT.should == 1
    RT_COMBINED_DYNAMIC.should == 2
    RT_REMOTE_SNAPSHOT.should == 3
    RT_REMOVE_DELETED.should == 4
    RT_REMOTE_ONLINE.should == 8

    # module TDataStreamState
    DS_STATE_CLOSE.should == 0
    DS_STATE_LOCAL_SNAPSHOT.should == 1
    DS_STATE_REMOTE_SNAPSHOT.should == 2
    DS_STATE_ONLINE.should == 3
    DS_STATE_CLOSE_COMPLETE.should == 4
    DS_STATE_REOPEN.should == 5
    DS_STATE_ERROR.should == 6

    # Error codes
    P2ERR_OK.should == 0x0000
    P2ERR_COMMON_BEGIN.should == 0x0000

    P2MQ_ERRORCLASS_OK.should == 0x0000
    P2MQ_ERRORCLASS_IS_USELESS.should == 0x0001
  end

  it 'has error handler'do
    expect { error 'Blah'}.to raise_error P2::Error, /Blah/
  end
end

