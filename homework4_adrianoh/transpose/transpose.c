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
#include <stdio.h>
#include <stdlib.h>

#include "../fasttime.h"

// This convenience macro indexes into double* A
// as a 2D array of row-length n.
// A and n must be defined in the current scope.
#define GET(i, j) (A[n * i + j])

// Uncomment to disable cilk usage
#define USE_CLK

void transpose(double* A, int n) {
  #ifdef USE_CLK
  cilk_for
  #else
  for 
  #endif
   (int i = 0; i < n; i++) {
    for (int j = 0; j < i; j++) {
      double temp = GET(i, j);
      GET(i, j) = GET(j, i);
      GET(j, i) = temp;
    }
  }
}

void print(double* A, int n) {
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      printf("%4.0f ", GET(i, j));
    }
    printf("\n");
  }
}

int main(int argc, char* argv[]) {
  int n = 4;
  int printFlag = 1;

  if (argc > 1) {
    n = atoi(argv[1]);
    printFlag = 0;
  }
  if (argc > 2) {
    printFlag = atoi(argv[2]);
  }

  double* A = malloc(sizeof(double) * n * n);

  double count = 0.0;
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      GET(i, j) = count;
      count += 1.0;
    }
  }

  if (printFlag == 1) {
    printf("Original:\n");
    print(A, n);
  }

  fasttime_t start_time = gettime();
  transpose(A, n);
  fasttime_t stop_time = gettime();

  if (printFlag == 1) {
    printf("Transposed:\n");
    print(A, n);
  }

  printf("Elapsed time: %f sec\n", tdiff_sec(start_time, stop_time));

  return 0;
}
