#!/usr/bin/env ruby

file = open('noto-hinting.txt', 'r:UTF-8')

fonts = []
tmp = ''
hinted = open('noto-hinted.txt', 'w:UTF-8')
non_hinted = open('noto-non-hinted.txt', 'w:UTF-8')

file.each_line do |l|
  next if l.strip.end_with?('.ttf')
  tmp += l if l.strip.index('_')
  next unless l.strip.end_with?('true', 'false')
  next if tmp.empty?
  tmp += l
  fonts << tmp
  tmp = ''
end

file.close

fonts.map! do |f|
  a = f.split("\n")
  s = a.size
  ui = a.select { |m| m.end_with?('_UI') }
  if s < 3
    a
  elsif !ui.empty?
    [ui[0], a[-1]]
  else
    idx = a[0].split('_').size - 1
    r = Regexp.new('^' + '[[:alnum:]]+_' * idx + '[[:alnum:]]+')
    a.each_with_index do |i, j|
      next if j.zero? || j == s - 1
      a[j] = r.match(i)[0]
    end.uniq!
  end
end

fonts.each do |i|
  next if i[0].index('Emoji')
  if i[1].strip.end_with?('true')
    hinted.write i[0] + "\n"
  else
    non_hinted.write i[0] + "\n"
  end
end

hinted.close
non_hinted.close
