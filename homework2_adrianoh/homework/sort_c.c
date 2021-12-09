/**
 * Copyright (c) 2012 MIT License by 6.172 Staff
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


#include "./util.h"

#define THRESHOLD 64

// Function prototypes
static void merge_c(data_t* A, int p, int q, int r);
static void copy_c(data_t* source, data_t* dest, int n);
static void merge_c_h(data_t* start, data_t* end);
static void sort_c_h(data_t* start, data_t* end);

// A basic merge sort routine that sorts the subarray A[p..r]
void sort_c(data_t* A, int p, int r) {
  assert(A);
  sort_c_h(A + p, A + r);
}

inline __attribute__ ((always_inline)) void isort(data_t* begin, data_t* end) {
  data_t* cur = begin + 1;
  while (cur <= end) {
    data_t val = *cur;
    data_t* index = cur - 1;

    while (index >= begin && *index > val) {
      *(index + 1) = *index;
      index--;
    }

    *(index + 1) = val;
    cur++;
  }
}

void sort_c_h(data_t* start, data_t* end) {
  if (end - start > THRESHOLD) {
    data_t* mid = start + (end - start) / 2;
    sort_c_h(start, mid);
    sort_c_h(mid + 1, end);
    merge_c_h(start, end);
    return;
  }
  isort(start, end);
}

inline __attribute__ ((always_inline)) static void merge_c_h(data_t* start, data_t* end) {
  // Copied to avoid write to stack :)
  data_t* mid = start + (end - start) / 2;

  assert(start);
  assert(start <= mid);
  assert(mid + 1 <= end);
  assert((uint64_t)mid % (uint64_t)sizeof(data_t) == 0);

  // C is tricky and when you do pointer arithmetic it changes the offsets by a sizeof(data_t) factor
  data_t* left = (data_t*) malloc(sizeof(data_t) * (mid - start + 1 + 1));
  assert(sizeof(data_t) * (mid - start + 1 + 1) == (uint64_t)mid - (uint64_t)start + 2*sizeof(data_t));
  data_t* right = (data_t*) malloc(sizeof(data_t) * (end - mid + 1));
  assert(sizeof(data_t) * (end - mid + 1) == (uint64_t)end - (uint64_t)mid + sizeof(data_t));

  if (left == NULL || right == NULL) {
    free(left);
    free(right);
    printf("OOM\n");
    return;
  }

  data_t* traverse = start;
  data_t* left_c = left;
  data_t* right_c = right;
  while (traverse <= mid) {
    *(left_c++) = *(traverse++);
  }
  *left_c = UINT_MAX;
  while (traverse <= end) {
    *(right_c++) = *(traverse++);
  }
  *right_c = UINT_MAX;
  assert(left < left_c);
  assert(right < right_c);

  traverse = start;
  left_c = left;
  right_c = right;
  while (traverse <= end) {
    if (*left_c <= *right_c) {
      *(traverse++) = *(left_c++);
    } else {
      *(traverse++) = *(right_c++);
    }
  }
  assert(left < left_c);
  assert(right < right_c);
  free(left);
  free(right);
}
