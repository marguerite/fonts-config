#!/usr/bin/env ruby

require 'fileutils'

FONT_BINARY_DIR = '/home/marguerite/binaries'.freeze

file = open('noto-info.txt', 'r:UTF-8')

output = open('noto-hinting.txt', 'w:UTF-8')
fonts = file.read.split(/(^.*?rpm)/).reject(&:empty?)
file.close
fonts = fonts.zip(fonts.rotate(1))
fonts = fonts.values_at(* fonts.each_index.select(&:even?)).map! { |i| [i[0], i[1].strip.split("\n")].flatten! }.map! do |j|
  j.reject { |l| l.strip.start_with?(':') }
end

fonts.each do |n|
  n[1..-1].each do |i|
    puts i + "\n"
    output.write i + "\n"
  end
  cmd = "unrpm #{FONT_BINARY_DIR}/#{n[0].sub('47.1', '46.2')}"
  IO.popen(cmd) { |f| puts f.gets }
  puts "broken command #{cmd}\n" unless $?
  Dir.glob(Dir.pwd + '/usr/share/fonts/truetype/*') do |d|
    puts d + "\n"
    output.write File.basename(d) + "\n"
    c = "./fonthint -f #{d}"
    IO.popen(c) do |f|
      t = f.gets
      output.write t
      puts t
    end
    puts "broken command #{c}\n" unless $?
  end
  FileUtils.rm_rf(Dir.pwd + '/usr')
end

output.close
