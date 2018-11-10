#!/bin/sh

for i in "Source Han Sans SC" "Source Han Sans TC" "Source Han Sans JP" "Source Han Sans KR" "Source Han Sans CJK" "Source Han Sans CJK SC" "Source Han Sans CJK TC" "Source Han Sans CJK JP" "Source Han Sans CJK KR" "Source Han Sans Mono CJK" "Source Han Sans Mono CJK SC" "Source Han Sans Mono CJK TC" "Source Han Sans Mono CJK JP" "Source Han Sans Mono CJK KR" "Source Han Serif SC" "Source Han Serif TC" "Source Han Serif JP" "Source Han Serif KR" "Source Han Serif CJK" "Source Han Serif CJK SC" "Source Han Serif CJK TC" "Source Han Serif CJK JP" "Source Han Serif CJK KR"; do
  echo "  <match target=\"font\">"
  echo "    <test name=\"family\">"
  echo "      <string>${i}</string>"
  echo "    </test>"
  echo "    <edit name=\"font_type\" mode=\"assign\">"
  echo "      <string>TT Instructed Font</string>"
  echo "    </edit>"
  echo "  </match>"
done
