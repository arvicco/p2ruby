# encoding: CP1251
require 'rspec'

describe 'RSpec' do
  it 'correctly outputs Windows Cyrillics' do
    pending 'RSpec does NOT output Windows Cyrillics, unless `chcp 1251` is run in console'
    Encoding.default_internal, Encoding.default_external = ['cp1251'] * 2
    lit = "Широкая электрификация южных губерний даст мощный толчок подъёму сельс"
    puts "Source encoding: #{__ENCODING__}"
    puts "Def ext/int encoding: #{Encoding.default_external}/#{Encoding.default_internal}"
    puts "String literal: #{lit} - encoding: #{lit.encoding}"

    lit.should == :miserable_failure
  end
end
