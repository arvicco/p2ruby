# encoding: CP1251
Encoding.default_internal, Encoding.default_external = ['utf-8'] * 2
text_cp1251 = 'Yes, Широкая электрификация южных губерний даст мощный толчок подъёму сельского хозяйства.!'
text_cp866 = text_cp1251.encode('CP866', :undef => :replace)
text_utf8 = text_cp1251.encode('UTF-8')

#puts  "#{text_cp1251}-#{text_cp1251.encoding}, #{text_cp866}-#{text_cp866.encoding}, #{text_utf8}-#{text_utf8.encoding}"

puts 'Playing with encodings: default encodings'
puts"Source encoding: #{__ENCODING__}"
puts"Def ext/int encoding: #{Encoding.default_external}/#{Encoding.default_internal}"
puts"String literal: #{text_cp1251} - encoding: #{text_cp1251.encoding}"

puts

puts 'Playing with encodings: setting default to utf-8'
Encoding.default_internal, Encoding.default_external = ['utf-8'] * 2
puts"Def ext/int encoding: #{Encoding.default_external}/#{Encoding.default_internal}"

puts"Literal: #{text_cp1251} - encoding: #{text_cp1251.encoding}"
puts"Encoded to CP866: #{text_cp866} - encoding: #{text_cp866.encoding}"
puts"Encoded to UTF8: #{text_utf8} - encoding: #{text_utf8.encoding}"

puts

puts 'Playing with encodings: setting default to cp866'
Encoding.default_internal, Encoding.default_external = ['cp866'] * 2
puts"Def ext/int encoding: #{Encoding.default_external}/#{Encoding.default_internal}"

puts"Literal: #{text_cp1251} - encoding: #{text_cp1251.encoding}"
puts"Encoded to CP866: #{text_cp866} -encoding: #{text_cp866.encoding}"
puts"Encoded to UTF8: #{text_utf8} -encoding: #{text_utf8.encoding}"
