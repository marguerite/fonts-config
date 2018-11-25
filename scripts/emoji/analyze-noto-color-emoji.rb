#!/usr/bin/env ruby
#
# Generate unicode codepoints from Noto Color Emoji's builtin charsets, substract the common emoji unicode codepoints, and output the left.
# The purpose of this script is to find if Noto Color Empji provides whitespace characters that may break the prepend work.
#

require 'nokogiri'
require 'open-uri'
require '../fontsconf.rb'
include FontsConf

cmd = `fc-scan --format "%{charset}" /usr/share/fonts/truetype/NotoColorEmoji.ttf`
html = Nokogiri::HTML(open('https://gist.github.com/janlelis/72f9be1f0ecca07372c64cf13894b801'))
emoji_chars = []
emoji_charset = []

html.css('h3').each do |node|
  emoji_chars += node.next_element.css('.g-emoji').map do |emoji|
    emoji.text.chars.map do |c|
      c.ord.to_s(16)
    end.join(' ')
  end
end

emoji_chars.each do |i|
  if i.index(' ')
    # emoji font are char based, we have to break the sequences
    i.split(' ').each { |j| emoji_charset << j }
  else
    emoji_charset << i
  end
end

emoji_charset = sort_charset(emoji_charset)

noto = []

cmd.split(' ').each do |i|
  if i.index('-')
    FontsConf.send(:extract_range, i).each { |j| noto << j }
  else
    noto << i
  end
end

noto.reject { |i| emoji_charset.include?(i) }.each do |j|
  puts j
  puts '"' + [('0x' + j).hex].pack('U') + '"'
end
