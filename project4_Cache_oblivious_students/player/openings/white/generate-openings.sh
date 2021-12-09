#!/bin/bash

num_ply=9
# file counters for reading and writing
write_counter=45
read_counter=18

while [ $(wc -l < opening-${read_counter}.txt) -lt $num_ply ]
do
  rm -f results
  # generate all opponent responses at depth 5-7
  cat opening-${read_counter}.txt search-7.txt | ../../leiserchess | tail -n 1 >> results &
  for i in `seq 1 48`; do cat opening-${read_counter}.txt search-6.txt | ../../leiserchess | tail -n 1 >> results & done
  for i in `seq 1 48`; do cat opening-${read_counter}.txt search-5.txt | ../../leiserchess | tail -n 1 >> results & done
  wait
  for i in $(cut results -d " " -f 2 | sort | uniq)
  do
    write_counter=$((write_counter+1))
    cp opening-${read_counter}.txt opening-${write_counter}.txt
    echo "move $i" >> opening-${write_counter}.txt
    # find best response at depth 7
    cat opening-${write_counter}.txt search-7.txt | ../../leiserchess | tail -n 1 | cut -d "t" -f 2 >> opening-${write_counter}.txt &
  done
  read_counter=$((read_counter+1))
done
wait
