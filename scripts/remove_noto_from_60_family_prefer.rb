#!/usr/bin/env ruby

# Remove <family>Noto *</family> stuff
# from 60-family-prefer.conf, since we
# have already aliased them in 49-family-default-noto.conf 
# and add 59-family-prefer-lang-specific-noto.conf
# so we don't need prefer and append_last for a same font

fp = open("../60-family-prefer.conf", "r:UTF-8")

noto_hinted = open("noto-hinted.txt", "r:UTF-8").read.split("\n")

noto_non_hinted = open("noto-non-hinted.txt","r:UTF-8").read.split("\n")

noto = (noto_hinted + noto_non_hinted).map {|i| i.gsub("_", " ") }

fp.each_line do |line|
  if line =~ %r{<family>(Noto.*?)</family>}
    unless noto.include?(Regexp.last_match(1))
      puts line
    end
  else
    puts line
  end
end
