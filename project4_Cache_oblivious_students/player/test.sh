#!/bin/bash
# run the test
cat test-input.txt | ./leiserchess > test-output.txt
# compare to known output
while IFS= read -r line
do
  grep -q "$line" test-output.txt || (echo "Test failed!" && exit 1)
done < known-output.txt
