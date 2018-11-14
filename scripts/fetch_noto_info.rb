#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'

html = Nokogiri::HTML(open('https://build.opensuse.org/package/binaries/home:MargueriteSu:branches:M17N:fonts/google-noto-fonts/openSUSE_Tumbleweed', 'r:UTF-8'))

rpms = html.css('div#content div ul:nth-of-type(1) li.binaries_list_item > text()').reject do |i|
  t = i.text.strip!
  t.empty? || !t.start_with?('noto')
end.map! do |j|
  j.text.match(/(.*)\(.*/)[1].strip!
end

file = open('noto-info.txt', 'w:UTF-8')

rpms.each do |i|
  puts i
  file.write i + "\n"
  uri = 'https://build.opensuse.org/package/binary/home:MargueriteSu:branches:M17N:fonts/google-noto-fonts/openSUSE_Tumbleweed/x86_64/' + i
  h = Nokogiri::HTML(open(uri, 'r:UTF-8'))
  h.xpath("//span[starts-with(@title, 'font(')]").each do |j|
    t = j.attribute('title').value.strip.match(/font\((.*)\)/)[1]
    unless t.start_with?('noto', 'font(noto')
      puts t
      file.write t + "\n"
    end
  end
end

file.close
