#!/usr/bin/env ruby

# Generate 81-emoji-blacklist-glyphs.conf

# Blacklist unicode codepints that are usually emoji
# from common fonts. such unicode codepoints are taken
# from Noto Color Emoji.

require '../fontsconf.rb'
include FontsConf

fonts = Dir.glob("/usr/share/fonts/truetype/**/*")
           .reject do |i|
              File.directory?(i) || i.end_with?(".dir") ||
              File.basename(i).start_with?("fonts") ||
              File.basename(i).index("Emoji")
           end

file = open("81-emoji-blacklist-glyphs.conf","w:UTF-8")

emoji = build_emoji_charset("/usr/share/fonts/truetype/NotoColorEmoji.ttf")

file.write print_preamble(Dir.pwd.match(%r{(fonts-config/.*)$})[1] + "/" + __FILE__)

font_hsh = {}

fonts.each do |f|
  charset = build_charset(f)
  intersect = intersect_charset(charset, emoji).uniq
  unless intersect.empty?
    fontname = `fc-scan --format "%{family}" #{f}`
    fontname = Regexp.last_match(1) if fontname =~ /^([^,]+),/
    if font_hsh.key?(fontname)
      font_hsh[fontname] += intersect
      font_hsh[fontname] = sort_charset(font_hsh[fontname])
    else
      font_hsh[fontname] = intersect
    end
  end
end

font_hsh.each {|k,v| file.write print_minus_block(k, ranged_charset(v))}

file.write "</fontconfig>"

file.close
