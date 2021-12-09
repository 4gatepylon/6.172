# Lecture from Jon Bentley
## Warmup problems
Generating all `n!` permutations.

Find all permutations of the digits `1...9` such that each initial substring of length `m` is divisible by `m`. Simple idea to generate the permutation and early stop if it's not divisible. All non-early stops are returned.

## Traveling Salesman
Maybe look at permutations of cities, fixing a prefix, and then finding the best subsequence.

MST bound.

MST + 2 edges bound.

Cities on the periphery are faster.

Sorting (and semi-sorting).

Caching MST.

Better computer + compiler optimizations.

Approximation? (didn't totally catch the details there)

Bell curve, but did not catch what exactly for (log node visits? while traveling or in the sense of the number of possible permutations to try?)

OR? Might be cool to explore...

Cutting planes? What's that?

...