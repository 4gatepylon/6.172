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
#define malloc(...) (USE_PACKED_MALLOC)
#define free(...) (USE_PACKED_FREE)
#define realloc(...) (USE_PACKED_REALLOC)

typedef struct used_header_t {
  size_t size;
} used_header_t;
#define HEADER_T_SIZE (ALLOC_ALIGN(sizeof(used_header_t)))

// packed_init - Does nothing.
int packed_init() { return 0; }

// packed_check - No checker.
int packed_check() { return 1; }

// packed_malloc - Allocate a block by incrementing the brk pointer.
void *packed_malloc(size_t size) {
  int packed_size = ALLOC_ALIGN(size + HEADER_T_SIZE);
  int spaghetti = (int)ALIGN_SHIFT_SIZE((uint64_t)((char*)mem_heap_hi() + 1), (uint64_t)packed_size, (uint64_t)CACHE_ALIGNMENT);
  used_header_t *hdr = mem_sbrk(spaghetti + packed_size);
  void *p = (char*)hdr + spaghetti;

  if (p) hdr->size = size;
  return p;
}

void packed_free(void *p) { /* no-op */ }

void *packed_realloc(void *ptr, size_t size) {
  // not used in this assignment
  return NULL;
}

// call mem_reset_brk.
void packed_reset_brk() { mem_reset_brk(); }

// call mem_heap_lo
void *packed_heap_lo() { return mem_heap_lo(); }

// call mem_heap_hi
void *packed_heap_hi() { return mem_heap_hi(); }
