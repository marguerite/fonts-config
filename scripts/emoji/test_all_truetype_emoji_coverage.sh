#!/bin/sh

for i in `ls /usr/share/fonts/truetype -I "NotoColorEmoji.ttf" -I "NotoEmoji.ttf"`; do
  ruby test_emoji_coverage.rb /usr/share/fonts/truetype/${i};
done
