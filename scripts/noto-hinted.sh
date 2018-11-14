#!/bin/sh

echo "<?xml version=\"1.0\" ?>"
echo "<!DOCTYPE fontconfig SYSTEM \"fonts.dtd\">"
echo "<fontconfig>"

for i in $(cat noto-hinted.txt); do
  J=$(echo $i | sed 's/_/ /g')
  echo "  <match target=\"font\">"
  echo "    <test name=\"family\">"
  echo "      <string>${J}</string>"
  echo "    </test>"
  echo "    <edit name=\"font_type\" mode=\"assign\">"
  echo "      <string>TT Instructed Font</string>"
  echo "    </edit>"
  echo "  </match>"
done

for i in "Noto Sans SC" "Noto Sans TC" "Noto Sans JP" "Noto Sans KR" "Noto Sans CJK" "Noto Sans CJK SC" "Noto Sans CJK TC" "Noto Sans CJK JP" "Noto Sans CJK KR" "Noto Sans Mono CJK" "Noto Sans Mono CJK SC" "Noto Sans Mono CJK TC" "Noto Sans Mono CJK JP" "Noto Sans Mono CJK KR" "Noto Serif SC" "Noto Serif TC" "Noto Serif JP" "Noto Serif KR" "Noto Serif CJK" "Noto Serif CJK SC" "Noto Serif CJK TC" "Noto Serif CJK JP" "Noto Serif CJK KR"; do
  echo "  <match target=\"font\">"
  echo "    <test name=\"family\">"
  echo "      <string>${i}</string>"
  echo "    </test>"
  echo "    <edit name=\"font_type\" mode=\"assign\">"
  echo "      <string>TT Instructed Font</string>"
  echo "    </edit>"
  echo "  </match>"
done

for i in "Source Han Sans CN" "Source Han Sans TW" "Source Han Sans JP" "Source Han Sans KR" "Source Han Sans CJK" "Source Han Sans CJK CN" "Source Han Sans CJK TW" "Source Han Sans CJK JP" "Source Han Sans CJK KR" "Source Han Sans Mono CJK" "Source Han Sans Mono CJK CN" "Source Han Sans Mono CJK TW" "Source Han Sans Mono CJK JP" "Source Han Sans Mono CJK KR" "Source Han Serif CN" "Source Han Serif TW" "Source Han Serif JP" "Source Han Serif KR" "Source Han Serif CJK" "Source Han Serif CJK CN" "Source Han Serif CJK TW" "Source Han Serif CJK JP" "Source Han Serif CJK KR"; do
  echo "  <match target=\"font\">"
  echo "    <test name=\"family\">"
  echo "      <string>${i}</string>"
  echo "    </test>"
  echo "    <edit name=\"font_type\" mode=\"assign\">"
  echo "      <string>TT Instructed Font</string>"
  echo "    </edit>"
  echo "  </match>"
done

echo "</fontconfig>"
