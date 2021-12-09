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

#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "./allocator_interface.h"
#include "./memlib.h"

// Don't call libc malloc!
#define malloc(...) (USE_FIXED_ALIGNED_MALLOC)
#define free(...) (USE_FIXED_ALIGNED_FREE)
#define realloc(...) (USE_FIXED_ALIGNED_REALLOC)

typedef struct free_list_t {
  struct free_list_t *next;
} free_list_t;

free_list_t *free_list;

int fixed_aligned_init() {
  // reset free list
  free_list = NULL;

  // printf("DIS IS THE INITTTTTTT\n");
  // Make sure that the hi is now aligned, so whenever we sbrk we are ok in the future
  mem_sbrk(ALIGN_SHIFT_SIZE((uint64_t)((char*)mem_heap_hi() + 1), (uint64_t)FIXED_SIZE, CACHE_ALIGNMENT));

  return 0;
}

// fixed_aligned_check - No checker.
int fixed_aligned_check() { return 1; }

// fixed_aligned_malloc - check free list, or allocate a cache-aligned fixed
// block
void *fixed_aligned_malloc(size_t size) {
  void *p = NULL;
  // printf("HIIII WE BE MALLOCING HAHA\n");
  assert(size <= FIXED_SIZE);

  if (free_list == NULL) {
    // IT should already be alligned
    assert(FIXED_SIZE == CACHE_ALIGNMENT);
    p = mem_sbrk(FIXED_SIZE);

    if (p == (void *)-1) {
      // The heap is probably full, so return NULL.
      return NULL;
    } else {
      return p;
    }
  } else {
    p = (void*)free_list;
    free_list = free_list->next;
    return p;
  }
}

void fixed_aligned_free(void *p) {
  ((free_list_t*)p)->next = free_list;
  free_list = (free_list_t*)p;
}

void *fixed_aligned_realloc(void *ptr, size_t size) {
  // not used in this assignment
  return NULL;
}

// call mem_reset_brk.
void fixed_aligned_reset_brk() { mem_reset_brk(); }

// call mem_heap_lo
void *fixed_aligned_heap_lo() { return mem_heap_lo(); }

// call mem_heap_hi
void *fixed_aligned_heap_hi() { return mem_heap_hi(); }
