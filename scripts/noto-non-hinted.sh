#!/bin/sh

echo "<?xml version=\"1.0\" ?>"
echo "<!DOCTYPE fontconfig SYSTEM \"fonts.dtd\">"
echo "<fontconfig>"
for i in $(cat noto-non-hinted.txt); do
  J=$(echo $i | sed 's/_/ /g')
  echo "  <match target=\"font\">"
  echo "    <test name=\"family\">"
  echo "      <string>${J}</string>"
  echo "    </test>"
  echo "    <edit name=\"font_type\" mode=\"assign\">"
  echo "      <string>NON TT Instructed Font</string>"
  echo "    </edit>"
  echo "  </match>"
done

echo "</fontconfig>"
