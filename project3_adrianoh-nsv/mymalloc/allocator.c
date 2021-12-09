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

#include "./allocator.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "./allocator_interface.h"
#include "./memlib.h"

// Don't call libc malloc!
#define malloc(...) (USE_MY_MALLOC)
#define free(...) (USE_MY_FREE)
#define realloc(...) (USE_MY_REALLOC)

// Note that we only really need 5 bits (for 32 powers), but we need to be eight byte aligned
// The header mask simply takes those lowest 5 bits
#define BITS31 31
#define BITS32 32
#define HEADER_SIZE 8
#define POW2(n) (1u << (n))
#define DIV2(n) ((n) >> 1)

// We choose this min block size since we need two pointers (each 8 bytes)
// And if we switch to four pointers we'll need 32 bytes
#define MIN_BLOCK_SIZE 16

// The bin sizes are the logs of the powers of 2 (the indices in the freelist) that mark
// the bounds of the sizes we will accept
#define NUM_BINS 32

typedef struct freelist_t {
  struct freelist_t* next;
  struct freelist_t* prev;
  // FEATURE: incude spatial_next
  // FEATURE: include spatial_prev
} freelist_t;

// Stores free blocks for re-use of size 2^k where k is in the index
// NOTE that this willt take up around 32 * 8 = 256 bytes of helper functionality
// (which is half the allowed amount of 512).
freelist_t* bins[NUM_BINS];

int my_check() {
  // Here we will want to check any internals
  // of the implementation. There are none for now....
  return 0;
}

// pointer arithmetic helpers
static inline void* padd(void* ptr, uint32_t amount) {
  return (void*)(((char*)ptr) + amount);
}

static inline void* psub(void* ptr, uint32_t amount) {
  return (void*)(((char*)ptr) - amount);
}

// helpers to quickly move from "user start" that
// doesn't include the header to "block_start" that does
static inline void* block_start(void* ptr) {
  return psub(ptr, HEADER_SIZE);
}

static inline void* user_start(void* ptr) {
  return padd(ptr, HEADER_SIZE);
}

// Return the header of a block given the "user start" pointer. 
// i.e. the size that the user malloc'd
static inline uint32_t header(void* ptr) {
  uint64_t* hdr_ptr = (uint64_t*)block_start(ptr);

  assert((char*)hdr_ptr < (char*)ptr);
  assert((char*)hdr_ptr + 8 == (char*)ptr);
  return *hdr_ptr;
}

// Return the size of a block given the "user start" pointer.
// i.e. size the user malloc'd + header size.
static inline uint32_t total_size(void* ptr) {
  return header(ptr) + HEADER_SIZE;
}

// Take in the size of a block that is requested and return the 
// size plus the header
static inline size_t size_with_header(size_t size) {
  return size + HEADER_SIZE;
}

// Assume that all requests will fit in under 2^31 bytes
// Return the log of the lowest power of 2 above the given size
static inline uint32_t pow2_floor(size_t x) {
  #define clz(n) __builtin_clz(n)
  uint32_t p = BITS31 - clz((uint32_t)x);

  assert((size_t)(1l << p) <= x);
  assert(p == 0 || (x <= (size_t)(1l << (p + 1))));
  return p;
}

// Assume min_size < pop_size but we want to avoid pop_size being too big
static inline uint_fast8_t size_ok_to_pop_now(uint32_t min_size, uint32_t pop_size) {
  uint32_t l = pow2_floor(min_size);
  assert(min_size <= pop_size);
  #define MX_BIN 31
  return l >= MX_BIN || (pop_size < min_size + DIV2(POW2(l + 1) - min_size));
}

// Assumes that bins[idx] != NULL and pops it out, if it is this will fail
static inline void* find_in_bin(uint32_t idx, uint32_t min_size) {
  freelist_t* test_fptr = bins[idx];
  void* fptr = NULL;

  assert(test_fptr != NULL);
  while (test_fptr != NULL) {
    uint32_t found_size = total_size((void*)test_fptr);
    assert(found_size >= (1u << idx));
    if (found_size >= min_size) {
      fptr = (void*)test_fptr;
      if (size_ok_to_pop_now(min_size, found_size)) {
        break;
      }
    }
    assert(test_fptr != test_fptr->next);
    test_fptr = test_fptr->next;
  }

  if (fptr == NULL) {
    return NULL;
  }

  assert(total_size(fptr) >= min_size);

  // Fix the pointers of the surrounding elements
  test_fptr = (freelist_t*)fptr;
  if (test_fptr->prev != NULL) {
    ((freelist_t*)(test_fptr->prev))->next = test_fptr->next;
  } else {
    bins[idx] = bins[idx]->next;
  }
  if (test_fptr->next != NULL) {
    ((freelist_t*)(test_fptr->next))->prev = test_fptr->prev;
  }

  assert((uint64_t)fptr % 8 == 0);
  assert((uint64_t)fptr <= (uint64_t)mem_heap_hi() + 1);
  assert(header(fptr) + HEADER_SIZE >= min_size);
  assert((uint64_t)fptr + header(fptr) <= (uint64_t)mem_heap_hi() + 1);

  #ifdef DEBUG_IN_HEAP_FINDINBIN
  if ((char*)mem_heap_lo() > (char*)fptr) {
    printf("life sucks\n");
    assert(0); // never happen plz
  }
  if ((char*)mem_heap_hi() < (char*)padd(fptr, min_size) - 1) {
    printf("life sucks a little less, assigned at %lu + %u -> (%lu), 
          but hi is %lu, min size %u\n", (uint64_t)fptr, header(fptr), 
          (uint64_t)padd(fptr, header(fptr)), (uint64_t)mem_heap_hi(), min_size);
  }
  #endif

  // This is not exhaustive, maybe we can add an assert in the list
  assert((char*)bins[idx] != (char*)fptr);
  return fptr;
}

// Assumes that bins[idx] != NULL and pops it out, if it is this will fail
static inline void* pop_bin(uint32_t idx) {
  void* ptr = (void*)bins[idx];
  assert(ptr != NULL);

  bins[idx] = bins[idx]->next;

  // maintain the invariant that the start of
  // bin has prev = NULL
  if (bins[idx] != NULL) {
    bins[idx]->prev = NULL;
  }
  assert((char*)bins[idx] != (char*)ptr);
  return ptr;
}

static inline void push_bin(void* ptr, uint32_t idx) {
  assert((char*)ptr != (char*)bins[idx]);
  ((freelist_t*)ptr)->next = (void*)bins[idx];
  ((freelist_t*)ptr)->prev = NULL;
  if(bins[idx] != NULL) {
    bins[idx]->prev = ptr;
  }
  bins[idx] = (freelist_t*)ptr;
}

// Get something from a bin that is guaranteed to have enough space for the requested memory size
// Assume that size includes the header
static inline void* cascade(uint32_t log_desired_size, uint32_t log_existing_size, uint32_t desired_size) {
  assert(log_desired_size == pow2_floor(desired_size));
  void* popped = pop_bin(log_existing_size);
  uint32_t leftover_size = total_size(popped) - desired_size;

  // We don't want leftovers that are too small, and we need a header anyways
  #define LOWEST_IDX 4
  if (leftover_size < HEADER_SIZE + (1u << LOWEST_IDX)) {
    return popped;
  }
  
  void* leftover = padd(block_start(popped), desired_size);
  *((uint64_t*)psub(popped, HEADER_SIZE)) = desired_size - HEADER_SIZE;
  *((uint64_t*)leftover) = leftover_size - HEADER_SIZE;

  uint32_t leftover_bin = pow2_floor(leftover_size);
  void* user = user_start(leftover);

  assert((uint64_t)user + leftover_size - HEADER_SIZE <= (uint64_t)mem_heap_hi() + 1);
  assert(header(user) + HEADER_SIZE >= (1u << leftover_bin));
  assert((uint64_t)(header(user) + HEADER_SIZE) < (1lu << (leftover_bin + 1)));
  assert(leftover_bin >= 4);
  assert(leftover_bin <= 31);

  push_bin(user, leftover_bin);
  return popped;
}

// Request for EXACTLY the given size (assumes header is included)
static inline void* request(uint32_t size) {
  uint32_t log_size = pow2_floor(size);
  // Try to pop from a bin if possible
  if (bins[log_size] != NULL) {
    void * popped = find_in_bin(log_size, size);
    if (popped != NULL) {
      assert((uint64_t)popped <= (uint64_t)mem_heap_hi() + 1);

      #ifdef DEBUG_REQ_1
        if ((uint64_t)popped + size -  HEADER_SIZE> (uint64_t)mem_heap_hi() + 1) {
          printf("popped %lu, popped + size %lu, memheaphi+1 $%lu, size was %d\n", 
              (uint64_t)popped, (uint64_t)popped + size, (uint64_t)mem_heap_hi() + 1, size);
        }
      #endif

      assert((uint64_t)popped + size - HEADER_SIZE<= (uint64_t)mem_heap_hi() + 1);
      return popped;
    }
  }
  // If we couldn't find anything in that bin, try to cascade from above
  for (uint32_t k = log_size + 1; k < NUM_BINS; k++) {
    if (bins[k] != NULL) {
      void* c = cascade(log_size, k, size);
      assert((uint64_t)c + size <= (uint64_t)mem_heap_hi() + 1);
      return c;
    }
  }

  // Simply sbrk the requested amount and store it
  assert(size % 8 == 0);
  void* new = mem_sbrk(size);
  
  // Probably out of heap space
  if (new == (void*)-1) {
    return NULL;
  }

  #ifdef DEBUG_IN_HEAP_SBRK
    if ((char*)mem_heap_lo() > (char*)new) {
      printf("life sucks\n");
      assert(0); // never happen plz
    }
    if ((char*)mem_heap_hi() < (char*)padd(new, size) - 1) {
      printf("life sucks a little less, assigned at %lu + %u -> (%lu), 
            but hi is %lu\n", (uint64_t)new, size, (uint64_t)padd(new, size), 
            (uint64_t)mem_heap_hi());
    }
  #endif

  // store total size - header in header
  *((uint64_t*)new) = size - HEADER_SIZE;
  void* user = user_start(new);

  assert((uint64_t)new + size <= (uint64_t)mem_heap_hi() + 1);
  assert((uint64_t)user % 8 == 0);
  return user;
}

static inline void* request_with_header(size_t size) {
  void* r = request(ALIGN(size_with_header(size)));
  assert(ALIGN(size_with_header(size)) >= size);
  assert(ALIGN(size_with_header(size)) % 8 == 0);
  assert(size_with_header(size) - 8 == size);
  assert(ALIGN(size_with_header(size)) >= size_with_header(size));
  assert((uint64_t)r + ALIGN(size_with_header(size)) - HEADER_SIZE <= (uint64_t)mem_heap_hi() + 1);
  return r;
}

// Initialization sets up our data structures.
int my_init() {
  // Initialize all the bins to null since 
  for (int i = 0; i < NUM_BINS; i++) {
    bins[i] = NULL;
  }

  // Ensure that the heap will be 8 byte aligned. We use induction to ensure that
  // this remains the state of the heap throughout our mallocs
  uint64_t next_heap = (uint64_t)padd(mem_heap_hi(), 1);
  if (ALIGN(next_heap) != next_heap) {
    mem_sbrk(ALIGN(next_heap));
  }

  assert(((uint64_t)mem_heap_hi()) % 8 != 0);
  return 0;
}

//  malloc - Allocate a block by incrementing the brk pointer.
//  Always allocate a block whose size is a multiple of the alignment.
void* my_malloc(size_t size) {
  // We do not allow super small mallocs
  if (size < MIN_BLOCK_SIZE) {
    size = MIN_BLOCK_SIZE;
  }
  void* r = request_with_header(size);
  assert((uint64_t)r + size <= (uint64_t)mem_heap_hi() + 1);
  assert((uint64_t)r + header(r) <= (uint64_t)mem_heap_hi() + 1);
  return r;
}

// Freeing simply inserts it into the corresponding bin as the new head (pointing to the old head)
void my_free(void* ptr) {
  uint32_t hdr_log = pow2_floor(header(ptr));
  push_bin(ptr, hdr_log);
}

void* my_realloc(void* ptr, size_t size) {
  if (ptr == NULL) {
    return my_malloc(size);
  }
  if (size == 0) {
    // This will never be tested for the project, but the intended behavior is to simply
    // run free. We return null because we have to return something. It does not signifiy an error.
    my_free(ptr);
    return NULL;
  }

  uint32_t current_size = header(ptr);
  if (current_size < size) {
    uint32_t og_size = header(ptr);
    if (padd(ptr, og_size) >= mem_heap_hi()) {
      // Thanks to Jeff! Don't forget to put this in the writeup
      void* s = mem_sbrk(size - og_size);
      if (s == (void*)-1) {
        return NULL;
      }
      assert((uint64_t)ptr + size <= (uint64_t)mem_heap_hi() + 1);
      *((uint64_t*)block_start(ptr)) = size;
      return ptr;
    }
    // If we cannot fit in this block, free it, and request a new one
    void* new_block = request_with_header(size);
    memcpy(new_block, ptr, current_size);
    my_free(ptr);
    assert((uint64_t)new_block + size - HEADER_SIZE <= (uint64_t)mem_heap_hi() + 1);
    return new_block;
  }
  // If the existing size was larger than the size plus the headersize, do nothing
  // In the future we may decide to shrink if necessary
  // i.e.
  // else if (pow2_floor(current_size) < pow2_floor(size)) {
  // return cascade_from_ptr();
  // }
  return ptr;
}
