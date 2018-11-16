#!/usr/bin/env ruby

file = open('noto-info.txt', 'r:UTF-8')
f = file.read
file.close

langs_list = f.split("\n").map(&:strip).select { |i| i.start_with?(':') }.uniq.map { |i| i.sub(':lang=', '') }

fonts = f.split(/^.*?rpm$/).map { |i| i.strip.split("\n") }
         .map do |j|
          if j.include?('Noto_Sans') || j.include?('Noto_Mono') || j.include?('Noto_Serif') || j.include?('Noto_Sans_Mono') || j.include?('Noto_Serif_Disp') || j.include?('Noto_Sans_Disp') || j.include?(':lang=und-zsye') || j.include?('Noto_Sans_Symbols')
            []
          else
            names = j.select { |k| k.start_with?('Noto') }.sort
            langs = j.select { |k| k.start_with?(':') }

            ui = names.select { |i| i.end_with?('_UI') }
            unless names.size < 2
              idx = names[0].split('_').size - 1
              r = Regexp.new('^' + '[[:alnum:]]+_' * idx + '[[:alnum:]]+')
              names.map! { |k| r.match(k)[0] }.uniq!
            end

            langs.map! { |k| k.sub(':lang=', '') } unless langs.empty?
            if ui.empty?
              [langs, names]
            else
              [langs, ui]
            end
          end
        end.reject { |k| k.empty? || k[0].empty? }

locals = langs_list.map do |i|
  a = [i]
  fonts.each do |j|
    next unless j[0].include?(i)
    j[1].each { |k| a << k }
  end
  a
end.reject { |i| i.size < 2 }

# prefer UI fonts
locals.each_with_index do |i, j|
  ui = i.select { |k| k.end_with?('_UI') }
  unless ui.empty?
    tmp = i.reject { |k| k.end_with?('_UI') }.rotate(1)[0..-2]
    locals[j] = [i[0]] + ui + tmp
  end
end

puts "<?xml version=\"1.0\" ?>"
puts "<!DOCTYPE fontconfig SYSTEM \"fonts.dtd\">"
puts "<fontconfig>"

locals.each do |i|
  sans = i.select{|m| m.index("_Sans_")}
  serif = i.select{|n| n.index("_Serif_")}
  todo = []
  [sans, serif].each {|k| todo << k unless k.empty? }

  todo.each do |v|
    font = v[0].index("_Sans_") ? "sans-serif" : "serif"
    puts "  <match target=\"pattern\">"
    puts "    <test qual=\"any\" name=\"family\" compare=\"eq\">"
    puts "      <string>#{font}</string>"
    puts "    </test>"
    puts "    <test name=\"lang\" compare=\"eq\">"
    puts "      <string>#{i[0]}</string>"
    puts "    </test>"
    puts "    <edit name=\"family\" mode=\"prepend\" binding=\"strong\">"
    v.each {|j| puts "      <string>#{j}</string>"}
    puts "    </edit>"
    puts "  </match>"
  end
end

puts "</fontconfig>"

