#include <stdio.h>
#include <stdlib.h>

// Disable red squiggly marks (check piazza)
#ifndef _CILK_H
#define  _CILK_H
#ifdef __cilk
#define cilk_spawn _Cilk_spawn
#define cilk_sync  _Cilk_sync
#define cilk_for   _Cilk_for
#else
#define cilk_spawn
#define cilk_sync (void) 0;
#define cilk_for for
#endif /* __cilk*/
#endif /* _CILK_H */

#include <cilk/cilk.h>

// Uncomment this to use print debugging
// #define DEBUG_BASE_CASE

// Comment or uncomment these two to decide whether to use these things
#define USE_CILK
#define COARSEN

// Decide how coarse to make the base case (linear algorithm below)
#define COARSEN_THRESHOLD 8

int fib(int n) {
  #ifndef COARSEN
  if (n < 2) {
    return n;
  }
  #else
  if (n <= COARSEN_THRESHOLD) {
    int temp;
    int bot = 0; // 0th
    int top = 1; // 1st
    for (int i = 2; i <= n; i++) {
      temp = bot;
      bot = top;
      // f(n + 1) = f(n) + f(n - 1)
      top += temp;
      #ifdef DEBUG_BASE_CASE
      printf("fib of %d is %d\n", i, top);
      #endif
    }
    return top;
  }
  #endif

  
  int x = 
  #ifdef USE_CILK
  cilk_spawn
  #endif
  fib(n - 1);

  int y = fib(n - 2);

  #ifdef USE_CILK
  cilk_sync;
  #endif

  return x + y;
}

int main(int argc, char* argv[]) {
  int n = 10;

  if (argc > 1) {
    n = atoi(argv[1]);
  }

  int result = fib(n);
  printf("fib(%d)=%d\n", n, result);

  return 0;
}
