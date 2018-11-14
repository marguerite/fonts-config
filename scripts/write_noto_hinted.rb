#!/usr/bin/env ruby

file = open("noto-hinting.txt", "r:UTF-8")

fonts = []
tmp = ""
hinted = []
non_hinted = []

file.each_line do |l|
	next if l.strip.end_with?(".ttf")
	tmp += l if l.strip.index("_")
	if l.strip.end_with?("true") || l.strip.end_with?("false")
	  unless tmp.empty?
            tmp += l
	    fonts << tmp
	    tmp = ""
	  end  
	end
end

file.close

fonts.each do |f|
  a = f.split("\n")
  if a[-1].strip.end_with?("true")
    a[0..-2].each {|i| hinted << i}
  else
    a[0..-2].each {|i| non_hinted << i}
  end
end

h = open("noto-hinted.txt", "w:UTF-8")
hinted.each {|i| h.write i + "\n"}
h.close

nh = open("noto-non-hinted.txt", "w:UTF-8")
non_hinted.each {|i| nh.write i + "\n"}
nh.close
