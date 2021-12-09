#!/bin/bash

num_ply=12
# file counters for reading and writing
read_counter=$1

# number of cores on machine
ncores=12

# initialize search files
for i in `seq 5 9`
do
  echo "go depth $i" > search-$i.txt
  echo "quit" >> search-$i.txt
done

if [ $(wc -l < opening-${read_counter}.txt) -lt $num_ply ]
then
  echo $read_counter
  rm -f results-${read_counter}
  # generate all opponent responses at depth 5-8
  cat opening-${read_counter}.txt search-8.txt | ../../leiserchess | tail -n 1 >> results-${read_counter}
  for i in `seq 1 4`; do cat opening-${read_counter}.txt search-7.txt | ../../leiserchess | tail -n 1 >> results-${read_counter}; done
  for i in `seq 1 16`; do cat opening-${read_counter}.txt search-6.txt | ../../leiserchess | tail -n 1 >> results-${read_counter}; done
  for i in `seq 1 64`; do cat opening-${read_counter}.txt search-5.txt | ../../leiserchess | tail -n 1 >> results-${read_counter}; done
  for i in $(cut results-${read_counter} -d " " -f 2 | sort | uniq)
  do
    # IMPORTANT: This is a race condition!  With high probability, it will never be triggered, so we'll just hope for the best
    write_counter=$(($(ls opening-[1-9]* | wc -l) + 1))
    cp opening-${read_counter}.txt opening-${write_counter}.txt
    echo "move $i" >> opening-${write_counter}.txt
    # find best response at depth 9 for first 4 ply, 8 after that
    if [ $(wc -l < opening-${read_counter}.txt) -lt 3 ]
    then
      cat opening-${write_counter}.txt search-9.txt | ../../leiserchess | tail -n 1 | cut -d "t" -f 2 >> opening-${write_counter}.txt 
    else
      cat opening-${write_counter}.txt search-8.txt | ../../leiserchess | tail -n 1 | cut -d "t" -f 2 >> opening-${write_counter}.txt 
    fi
    # only spawn $ncores jobs
    if [ $(pgrep leiserchess | wc -l) -lt $ncores ]
    then
      ../generate-openings.sh ${write_counter} &
    else
      ../generate-openings.sh ${write_counter} 
    fi
  done
fi
wait
