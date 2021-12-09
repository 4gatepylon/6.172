#!/bin/bash
# Run with command: `./full_correctness`
# This runs the correctness tests for render and simulate
# To solve permission denied error, run `chmod u+x full_correctness`
make clean && make DEBUG=1
SIMULATIONS="./simulations/*.txt"
for f in $SIMULATIONS
do
  printf "\n=== RUNNING $f ===\n"
  ./main -m -f $f
  ./ref_test -r
  ./ref_test -s
done
make clean
