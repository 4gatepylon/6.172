/**
 * Copyright (c) 2015 MIT License by 6.172 Staff
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

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "./allocator_interface.h"
#include "./memlib.h"

// Don't call libc malloc!
#define malloc(...) (USE_MY_MALLOC)
#define free(...) (USE_MY_FREE)
#define realloc(...) (USE_MY_REALLOC)

// All blocks must have a specified minimum alignment.
// The alignment requirement (from config.h) is >= 8 bytes.
#define ALIGNMENT 8

// Rounds up to the nearest multiple of ALIGNMENT.
#define ALIGN(size) (((size) + (ALIGNMENT - 1)) & ~(ALIGNMENT - 1))

// The smallest aligned size that will hold a size_t value.
#define SIZE_T_SIZE (ALIGN(sizeof(size_t)))

// We will allocate (for now) only for blocks of a given size
#ifndef BLOCK_SIZE
#define BLOCK_SIZE 1024 // default value
#endif

// Root will point to a freelist node which points to a freelist node and so on. To allocate we'll just
// return null if the block is too big, and otherwise assign an entire block from the free-list by picking the
// first element of the free-list. If we free, we'll simply set that block to be the freelist (i.e. the root).
// If we run out of list space we'll simply increase the heap size. We'll try to increase the heap size somewhat
// intelligently. We'll store a heap_size_inc variable which says how many blocks to increment the heap size by.
// Then, every time we free, we can reset the heap size increment amount. This means we call sbrk O(logN) times for
// length N runs of allocations. We will not have nodes with more than one block per node.
typedef struct struct_node_t {
  void* next;
} node_t;
node_t* head;

// check - This checks our invariant that the size_t header before every
// block points to either the beginning of the next block, or the end of the
// heap.
int simple_check() {
  // NOTE this is not actually used!
  char *p;
  char *lo = (char *)mem_heap_lo();
  char *hi = (char *)mem_heap_hi() + 1;
  size_t size = 0;

  p = lo;
  while (lo <= p && p < hi) {
    size = ALIGN(*(size_t *)p + SIZE_T_SIZE);
    p += size;
  }

  if (p != hi) {
    printf("Bad headers did not end at heap_hi!\n");
    printf("heap_lo: %p, heap_hi: %p, size: %lu, p: %p\n", lo, hi, size, p);
    return -1;
  }
  return 0;
}

// init - Initialize the malloc package.  Called once before any other
// calls are made.  Since this is a very simple implementation, we just
// return success.
int simple_init() {
  head = NULL;
  return 0;
}

//  malloc - Allocate a block by incrementing the brk pointer.
//  Always allocate a block whose size is a multiple of the alignment.
void *simple_malloc(size_t size) {
  if (size > BLOCK_SIZE) {
    return NULL;
  }

  if (head == NULL) {
    void* sbrked = mem_sbrk(BLOCK_SIZE);
    if (sbrked == (void *)-1) {
      return NULL;
    }
    return sbrked;
  } else {
    // Else we have something in the head
    void* ret_ptr = (void*)head;
    head = (node_t*)(head->next);
    return ret_ptr;
  }
}

// free - Freeing a block does nothing.
void simple_free(void *ptr) {
  ((node_t*)ptr)->next = head;
  head = (node_t*)ptr;
}

// realloc - Implemented simply in terms of malloc and free
void *simple_realloc(void *ptr, size_t size) {
  // We always return the same size, so there is nothing to do here
  return NULL;
}

// call mem_reset_brk.
void simple_reset_brk() { mem_reset_brk(); }

// call mem_heap_lo
void *simple_heap_lo() { return mem_heap_lo(); }

// call mem_heap_hi
void *simple_heap_hi() { return mem_heap_hi(); }
