#!/usr/bin/env ruby

file = open(ARGV[0], 'r:UTF-8')

a = file.read.split("\n").map do |i|
  i.strip.match(/^[[:alnum:]]+_[[:alnum:]]+(_[[:alnum:]]+)?/)[0]
end.uniq.size
p a
file.close
