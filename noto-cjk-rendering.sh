#!/bin/sh

echo "  <match target=\"font\">"

for i in "Noto Sans SC" "Noto Sans TC" "Noto Sans JP" "Noto Sans KR" "Noto Sans CJK" "Noto Sans CJK SC" "Noto Sans CJK TC" "Noto Sans CJK JP" "Noto Sans CJK KR" "Noto Sans Mono CJK" "Noto Sans Mono CJK SC" "Noto Sans Mono CJK TC" "Noto Sans Mono CJK JP" "Noto Sans Mono CJK KR" "Noto Serif SC" "Noto Serif TC" "Noto Serif JP" "Noto Serif KR" "Noto Serif CJK" "Noto Serif CJK SC" "Noto Serif CJK TC" "Noto Serif CJK JP" "Noto Serif CJK KR"; do
  echo "    <test name=\"family\" compare=\"eq\">"
  echo "      <string>${i}</string>"
  echo "    </test>"
done

for i in "Source Han Sans SC" "Source Han Sans TC" "Source Han Sans JP" "Source Han Sans KR" "Source Han Sans CJK" "Source Han Sans CJK SC" "Source Han Sans CJK TC" "Source Han Sans CJK JP" "Source Han Sans CJK KR" "Source Han Sans Mono CJK" "Source Han Sans Mono CJK SC" "Source Han Sans Mono CJK TC" "Source Han Sans Mono CJK JP" "Source Han Sans Mono CJK KR" "Source Han Serif SC" "Source Han Serif TC" "Source Han Serif JP" "Source Han Serif KR" "Source Han Serif CJK" "Source Han Serif CJK SC" "Source Han Serif CJK TC" "Source Han Serif CJK JP" "Source Han Serif CJK KR"; do
  echo "    <test name=\"family\" compare=\"eq\">"
  echo "      <string>${i}</string>"
  echo "    </test>"
done

echo "    <edit name=\"hintstyle\" mode=\"assign\">"
echo "      <string>hintfull</string>"
echo "    </edit>"
echo "  </match>"
