require 'spec_helper'

describe P2Ruby::Application do
  subject{P2Ruby::Application.new INI_PATH}

  it 'wraps P2ClientGate::P2Application OLE class' do
    p subject.ole_type
  end
end
