# encoding: CP1251
require 'rspec'

describe 'RSpec' do
  it 'correctly outputs Windows Cyrillics' do
#    pending 'freaking RSpec just does NOT output Cyrillics correctly, no matter what'
    Encoding.default_internal, Encoding.default_external = ['cp1251'] * 2
    lit = "ирокая электрификация южных губерний даст мощный толчок подъёму сельс"
    puts "Source encoding: #{__ENCODING__}"
    puts "Def ext/int encoding: #{Encoding.default_external}/#{Encoding.default_internal}"
    puts "String literal: #{lit} - encoding: #{lit.encoding}"

    lit.should == :miserable_failure
  end
end
