/**
 * Copyright (c) 2019 MIT License by 6.172 Staff
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 **/

#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#include "./fasttime.h"

// Definition of the floating-point element type of the matrices.
// Note that the base case size is 32 for us which is nice
typedef float el_t;
typedef float vfloat_t __attribute__((__vector_size__(32)));
// each float is 4 bytes so we will need 4 such vectors if we want to get a row
// Avec, Bvec and Cvec each hold an entire row

// Base case of the matrix multiplication.  This base case computes a
// product between two size x size tiles of elements in A and B, and
// stores the result in C.  This code assumes that matrices A, B, and
// C are all in row-major order, and the variable row_length stores
// the length of a row in the input matrices A, B, or C.
void matmul_base(el_t *restrict C, const el_t *restrict A,
                 const el_t *restrict B, int row_length, int size) {
  // So that we'll use the correct alignment
  A = __builtin_assume_aligned(A, 32);
  B = __builtin_assume_aligned(B, 32);
  C = __builtin_assume_aligned(C, 32);

  vfloat_t Avec[4], Bvec[4], Cvec[4];

  if (size != 32) {
    printf("Wrong block size: %d; Want: 32\n", size);
    size /= 0; // :)
  }

  float a;
  // SIZE IS ALWAYS 32 (for big matrices, which are the only ones we'll use)
  for (int ACrow = 0; ACrow < 32; ACrow++) {

    // Load A and C row int othe vectors
    for (int v = 0; v < 4; v++) {
      for(int e = 0; e < 8; e++) {
        Avec[v][e] = A[(ACrow * row_length) + (v * 8) + e];
        Cvec[v][e] = 0;
      }
    }

    // Now we want to load B
    // OUTER
    for (int Brow = 0; Brow < 32; Brow++) {
      // Hurray for copypasta!
      for (int v = 0; v < 4; v++) {
        for (int e = 0; e < 8; e++) {
          Bvec[v][e] = B[(Brow * row_length) + (v * 8) + e];
        }
      }

      a = Avec[Brow / 8][Brow % 8];
      Cvec[0] += a * Bvec[0];
      Cvec[1] += a * Bvec[1];
      Cvec[2] += a * Bvec[2];
      Cvec[3] += a * Bvec[3];
    }
    // END OUTER

    // Write back into C
    for (int v = 0; v < 4; v++) {
      for (int e = 0; e < 8; e++) {
        C[(ACrow * row_length) + (v * 8) + e] += Cvec[v][e];
      }
    }
  }
}

// Helper method to check if two given floating-point values are close
// enough.
static bool close_enough(el_t x, el_t y) {
  // Canonicalize the input
  x = (x < 0) ? -x : x;
  y = (y < 0) ? -y : y;
  if (x < y) {
    el_t tmp = x;
    x = y;
    y = tmp;
  }

  el_t diff = x - y;
  assert(diff >= 0 && "Invalid difference");
  return (diff < 0.01) || (diff / x < 0.00001);
}

// Check that the given n-by-n matrix C is the matrix product of the
// n-by-n matrices A and B.  We prevent inlining on this function,
// because it is not performance critical and preventing inlining
// makes it easier to interpret perf results.
__attribute__((noinline))
static bool check_correctness(const el_t *restrict C, const el_t *restrict A,
                              const el_t *restrict B, int n) {
  bool passed = true;
  fprintf(stderr, "Checking correctness.\n");
  // Multiply the matrices in the naive way.
  el_t *Ctmp = (el_t *)malloc(n * n * sizeof(el_t));
  for (int i = 0; i < n; ++i) {
    for (int j = 0; j < n; ++j) {
      Ctmp[i*n + j] = 0;
    }
  }
  for (int i = 0; i < n; ++i) {
    for (int j = 0; j < n; ++j) {
      for (int k = 0; k < n; ++k) {
        Ctmp[i*n + j] += A[i*n + k] * B[k*n + j];
      }
    }
  }
  for (int i = 0; i < n; ++i) {
    for (int j = 0; j < n; ++j) {
      if (!close_enough(C[i*n + j], Ctmp[i*n + j])) {
        passed = false;
        fprintf(stderr, "Unexpected value found in matrix product: "
                "  C[%d,%d] = %f, expected %f\n",
                i, j, C[i*n + j], Ctmp[i*n + j]);
      }
    }
  }
  if (!passed)
    fprintf(stderr, "FAILED correctness check.\n");
  else
    fprintf(stderr, "PASSED correctness check.\n");

  free(Ctmp);
  return passed;
}

int main(int argc, char *argv[]) {
  // By default, operate on 1024x1024 matrices, but allow an argument
  // to specify the log_2 of another square matrix size.
  int lg_n = 10;
  if (argc > 1)
    lg_n = atoi(argv[1]);

  // Dimensions of the matrices.
  const int n = 1 << lg_n;
  // Size of the base case.
  const int size = (n > 32) ? 32 : n;
  assert(n % size == 0 &&
         "Matrix size is not a multiple of the base-case size.");

  // Allocate the matrices.
  el_t *A = (el_t *)malloc(n * n * sizeof(el_t));
  el_t *B = (el_t *)malloc(n * n * sizeof(el_t));
  el_t *C = (el_t *)malloc(n * n * sizeof(el_t));

  // Initialize the matrices.
  for (int i = 0; i < n; ++i) {
    for (int j = 0; j < n; ++j) {
      A[i*n + j] = (el_t)rand() / (el_t)RAND_MAX;
      B[i*n + j] = (el_t)rand() / (el_t)RAND_MAX;
      C[i*n + j] = 0;
    }
  }

  // Multiply the matrices.
  fasttime_t start = gettime();
  for (int i = 0; i < n; i += size) {
    for (int k = 0; k < n; k += size) {
      for (int j = 0; j < n; j += size) {
        matmul_base(&C[i*n + j], &A[i*n + k], &B[k*n + j], n, size);
      }
    }
  }
  fasttime_t end = gettime();

  // Report the running time.
  double elapsed = tdiff(start, end);
  printf("Running time: %f sec\n", elapsed);

  // Check the result.
  bool passed = check_correctness(C, A, B, n);

  // Free the memory of the matrices.
  free(A);
  free(B);
  free(C);

  // Return 0 if the matrix multiplcation succeeded, 1 otherwise.
  return !passed;
}
