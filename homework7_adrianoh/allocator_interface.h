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

#include <stdlib.h>

#ifndef _ALLOCATOR_INTERFACE_H
#define _ALLOCATOR_INTERFACE_H

// Called by the memory allocator when it needs to relocate
// a potentially live object.  Can return NULL if old object is no longer
// needed.
typedef void *(*relocate_callback_t)(void *state, void *old, void *new);

/* Function pointers for a malloc implementation.  This is used to allow a
 * single validator to operate on both libc malloc, a buggy malloc, and the
 * student "mm" malloc.
 */
typedef struct {
  int (*init)(void);
  void *(*malloc)(size_t size);
  void *(*realloc)(void *ptr, size_t size);
  void (*free)(void *ptr);
  int (*check)();
  void (*reset_brk)(void);
  void *(*heap_lo)(void);
  void *(*heap_hi)(void);

  /* non-standard API */
  void (*register_relocate_callback)(relocate_callback_t f, void *state);

  char *name;
  char aligned;
  char smart;
} malloc_impl_t;

int libc_init();
void *libc_malloc(size_t size);
void *libc_realloc(void *ptr, size_t size);
void libc_free(void *ptr);
int libc_check();
void libc_reset_brk();
void *libc_heap_lo();
void *libc_heap_hi();

static const malloc_impl_t libc_impl = {.name = "libc",
                                        .aligned = 0,
                                        .init = &libc_init,
                                        .malloc = &libc_malloc,
                                        .realloc = &libc_realloc,
                                        .free = &libc_free,
                                        .check = &libc_check,
                                        .reset_brk = &libc_reset_brk,
                                        .heap_lo = &libc_heap_lo,
                                        .heap_hi = &libc_heap_hi};

/* alignment helpers, alignment must be power of 2 */
#define ALIGNED(x, alignment) ((((uint64_t)x) & ((alignment)-1)) == 0)
#define ALIGN_FORWARD(x, alignment) \
  ((((uint64_t)x) + ((alignment)-1)) & (~((uint64_t)(alignment)-1)))
#define ALIGN_BACKWARD(x, alignment) \
  (((uint64_t)x) & (~((uint64_t)(alignment)-1)))
#define PAD(length, alignment) (ALIGN_FORWARD((length), (alignment)) - (length))
#define ALIGN_MOD(addr, size, alignment) \
  ((((uint64_t)addr) + (size)-1) & ((alignment)-1))
#define CROSSES_ALIGNMENT(addr, size, alignment) \
  (ALIGN_MOD(addr, size, alignment) < (size)-1)
/* number of bytes you need to shift addr forward so that it's
 * !CROSSES_ALIGNMENT */
#define ALIGN_SHIFT_SIZE(addr, size, alignment)        \
  (CROSSES_ALIGNMENT(addr, size, alignment)            \
       ? ((size)-1 - ALIGN_MOD(addr, size, alignment)) \
       : 0)

// All blocks must have a specified minimum alignment.
// The alignment requirement (from config.h) is >= 8 bytes.
#define ALLOC_ALIGNMENT 8
#define ALLOC_ALIGN(size) ALIGN_FORWARD(size, ALLOC_ALIGNMENT)

#define CACHE_ALIGNMENT 64
#define CACHE_ALIGN(size) ALIGN_FORWARD(size, CACHE_ALIGNMENT)

int wrapped_init();
void *wrapped_malloc(size_t size);
void *wrapped_realloc(void *ptr, size_t size);
void wrapped_free(void *ptr);
int wrapped_check();
void wrapped_reset_brk();
void *wrapped_heap_lo();
void *wrapped_heap_hi();

static const malloc_impl_t wrapped_impl = {.name = "wrapped",
                                           .aligned = 1,
                                           .init = &wrapped_init,
                                           .malloc = &wrapped_malloc,
                                           .realloc = &wrapped_realloc,
                                           .free = &wrapped_free,
                                           .check = &wrapped_check,
                                           .reset_brk = &wrapped_reset_brk,
                                           .heap_lo = &wrapped_heap_lo,
                                           .heap_hi = &wrapped_heap_hi};

int packed_init();
void *packed_malloc(size_t size);
void *packed_realloc(void *ptr, size_t size);
void packed_free(void *ptr);
int packed_check();
void packed_reset_brk();
void *packed_heap_lo();
void *packed_heap_hi();

static const malloc_impl_t packed_impl = {.name = "packed",
                                          .aligned = 1,
                                          .init = &packed_init,
                                          .malloc = &packed_malloc,
                                          .realloc = &packed_realloc,
                                          .free = &packed_free,
                                          .check = &packed_check,
                                          .reset_brk = &packed_reset_brk,
                                          .heap_lo = &packed_heap_lo,
                                          .heap_hi = &packed_heap_hi};

int simple_init();
void *simple_malloc(size_t size);
void *simple_realloc(void *ptr, size_t size);
void simple_free(void *ptr);
int simple_check();
void simple_reset_brk();
void *simple_heap_lo();
void *simple_heap_hi();
void simple_register_relocate_callback(relocate_callback_t f, void *state);

static const malloc_impl_t simple_impl = {.name = "simple",
                                          .aligned = 1,
                                          .init = &simple_init,
                                          .malloc = &simple_malloc,
                                          .realloc = &simple_realloc,
                                          .free = &simple_free,
                                          .check = &simple_check,
                                          .reset_brk = &simple_reset_brk,
                                          .heap_lo = &simple_heap_lo,
                                          .heap_hi = &simple_heap_hi};

int smart_init();
void *smart_malloc(size_t size);
void *smart_realloc(void *ptr, size_t size);
void smart_free(void *ptr);
int smart_check();
void smart_reset_brk();
void *smart_heap_lo();
void *smart_heap_hi();
void smart_register_relocate_callback(relocate_callback_t f, void *state);

#define SMALL_SIZE 32
#define LARGE_SIZE 64
#define IS_LARGE(p) !(IS_SMALL(p))

#define SMART_PTR(p) ((void*)((uint64_t)p & ~1))
#define IS_SMALL(p) ((uint64_t)p & 1)

static const malloc_impl_t smart_impl = {
    .name = "smart",
    .aligned = 1,
    .smart = 1,
    .init = &smart_init,
    .malloc = &smart_malloc,
    .realloc = &smart_realloc,
    .free = &smart_free,
    .check = &smart_check,
    .reset_brk = &smart_reset_brk,
    .heap_lo = &smart_heap_lo,
    .heap_hi = &smart_heap_hi,
    .register_relocate_callback = &smart_register_relocate_callback};

#define FIXED_SIZE LARGE_SIZE
int fixed_aligned_init();
void *fixed_aligned_malloc(size_t size);
void *fixed_aligned_realloc(void *ptr, size_t size);
void fixed_aligned_free(void *ptr);
int fixed_aligned_check();
void fixed_aligned_reset_brk();
void *fixed_aligned_heap_lo();
void *fixed_aligned_heap_hi();

static const malloc_impl_t fixed_aligned_impl = {
    .name = "fixed",
    .aligned = 1,
    .init = &fixed_aligned_init,
    .malloc = &fixed_aligned_malloc,
    .realloc = &fixed_aligned_realloc,
    .free = &fixed_aligned_free,
    .check = &fixed_aligned_check,
    .reset_brk = &fixed_aligned_reset_brk,
    .heap_lo = &fixed_aligned_heap_lo,
    .heap_hi = &fixed_aligned_heap_hi};

#endif  // _ALLOCATOR_INTERFACE_H
