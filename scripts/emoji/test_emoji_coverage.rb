#!/usr/bin/env ruby

# Test if emoji unicode points provided by emoji font
# exists in the given font
# Usage: ./test_emoji_coverage.rb  /usr/share/fonts/truetype/DejaVuSans.ttf

require '../fontsconf.rb'

include FontsConf

emoji_font = ARGV[1] || "/usr/share/fonts/truetype/NotoColorEmoji.ttf"

emoji = build_emoji_charset(emoji_font)

charset = build_charset(ARGV[0])

intersect = intersect_charset(charset, emoji)

unless intersect.empty?
  puts ARGV[0]
  # print intersect content to screen
  intersect.each do |i|
    puts "Unicode Codepoint: 0x" + i
    puts "Character: " + '"' + [('0x' + i).hex].pack('U') + '"'
  end
end
