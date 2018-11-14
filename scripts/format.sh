#!/bin/sh

for i in `ls *.conf`; do
  xmllint --format ${i} > ${i}.new;
  mv ${i}.new ${i};
done
