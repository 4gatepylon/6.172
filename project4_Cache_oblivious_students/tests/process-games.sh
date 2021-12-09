#!/bin/bash

# extract all games
grep "[0-9]\. " basic.pgn | sed -e "s/{[0-9]* [0-9]* [0-9]*}//g" -e "s/[0-9]*\.//g" | tr -s " " > all-games.txt

# create directories
rm -rf win lose draw
mkdir -p win lose draw

# chop into files
ends=$(grep -n "-" all-games.txt | cut -d ":" -f 1 | less)
counter=0
old_i=0
for i in $ends
do
  diff=$((i-old_i))
  head all-games.txt -n $i | tail -n $diff > game-$counter.txt
  old_i=$i
  counter=$((counter+1))
done

counter=$((counter-1))

# sort games based on win/loss
for i in `seq 0 $counter`
do
  grep -q "1-0" game-$i.txt && folder="win"
  grep -q "0-1" game-$i.txt && folder="lose"
  grep -q "1/2-1/2" game-$i.txt && folder="draw"
  grep -o "[a-z][0-9][^ ]*" game-$i.txt | sed -e "s/^/move /" -e "s/$/\neval/" > $folder/game-$i.txt
  echo "quit" >> $folder/game-$i.txt
  cat $folder/game-$i.txt | ../player/leiserchess | grep Total | grep -o -- "-*[0-9]*" > $folder/result-$i.txt
done

# clean up
rm -f all-games game-*.txt
