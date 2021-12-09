#!/bin/bash

# find maximum opening depth
max_depth=$(wc -l */opening-*.txt | head -n -1 | sort -n | tr -s " " | less | cut -d " " -f 2 | tail -n 1)

# determine how many openings there are of each depth
# NOTE: This assumes that we have at least one opening of each depth (up to max depth)
# The tail at the end strips off the zero-length opening (used for starting black's search)
lengths=$(wc -l */opening-*.txt | head -n -1 | sort -n | tr -s " " | less | cut -d " " -f 2 | uniq -c | tr -s " " | cut -d " " -f 2 | tail -n +2)

rm -f lookup.h
echo "// This file is auto-generated; do not edit!" >> lookup.h
echo "#ifndef LOOKUP_H" >> lookup.h
echo "#define LOOKUP_H" >> lookup.h
echo "#define OPEN_BOOK_DEPTH $max_depth" >> lookup.h
echo $(echo "int lookup_sizes[OPEN_BOOK_DEPTH] = {"; echo $lengths | sed -e 's/ /, 2 \\* /g'; echo "};") >> lookup.h
sed -i lookup.h -e 's/\\\*/*/g'

for depth in `seq 1 $max_depth`
do
  echo "const char* lookup_table_${depth}[] = {" >> lookup.h
  num_files=$(wc -l */opening-*.txt | head -n -1 | tail -n +2 | grep " $depth " | wc -l)
  counter=0
  for file in */opening-*.txt
  do
    if [ $(wc -l < $file) -eq $depth ]
    then
      counter=$((counter+1))
      echo $(echo "\""; echo $(head -n -1 $file | cut -d " " -f 2); echo "\",") | sed -e "s/ //g" >> lookup.h
      if [ $counter -lt $num_files ]
      then
        echo $(echo "\""; echo $(tail -n 1 $file | cut -d " " -f 2); echo "\",") | sed -e "s/ //g" >> lookup.h
      else
        echo $(echo "\""; echo $(tail -n 1 $file | cut -d " " -f 2); echo "\"") | sed -e "s/ //g" >> lookup.h
      fi
    fi
  done
  echo "};" >> lookup.h
done

echo "const char** lookup_tables[OPEN_BOOK_DEPTH] = {" >> lookup.h
for depth in `seq 1 $((max_depth-1))`
do
  echo "lookup_table_${depth}," >> lookup.h
done
echo "lookup_table_${max_depth}};" >> lookup.h

echo "#endif" >> lookup.h
