/*
 * memlib.c - a module that simulates the memory system.  Needed because it
 *            allows us to interleave calls from the student's malloc package
 *            with the system's malloc package in libc.
 */
#include "./memlib.h"

#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

#include "./config.h"

/* private variables */
static char *mem_start_brk; /* points to first byte of heap */
static char *mem_brk;       /* points to first byte outside of heap */
static char *mem_max_addr;  /* largest legal heap address */

/*
 * mem_init - initialize the memory system model
 */
void mem_init(void) {
  /* allocate the storage we will use to model the available VM */
  if ((mem_start_brk = (char *)malloc(MAX_HEAP)) == NULL) {
    fprintf(stderr, "mem_init_vm: malloc error\n");
    exit(1);
  }

  mem_max_addr = mem_start_brk + MAX_HEAP; /* max legal heap address */
  mem_brk = mem_start_brk;                 /* heap is empty initially */
}

/*
 * mem_deinit - free the storage used by the memory system model
 */
void mem_deinit(void) { free(mem_start_brk); }

/*
 * mem_reset_brk - reset the simulated brk pointer to make an empty heap
 */
void mem_reset_brk(void) { mem_brk = mem_start_brk; }

/*
 * mem_sbrk - simple model of the sbrk function. Extends the heap
 *    by incr bytes and returns the start address of the new area. In
 *    this model, the heap cannot be shrunk.
 */
void *mem_sbrk(int incr) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-value"
#pragma GCC diagnostic ignored "-Wint-to-pointer-cast"

  char *old_brk = __sync_fetch_and_add(&mem_brk, (char *)incr);

  if ((incr < 0) || (mem_brk > mem_max_addr)) {
    errno = ENOMEM;
    fprintf(stderr, "ERROR: mem_sbrk failed. Ran out of memory... (%ld)\n",
            mem_heapsize());

    __sync_fetch_and_sub(&mem_brk, (char *)incr);

#pragma GCC diagnostic pop

    return (void *)-1;
  }

  return (void *)old_brk;
}

/*
 * mem_heap_lo - return address of the first heap byte
 */
void *mem_heap_lo(void) { return (void *)mem_start_brk; }

/*
 * mem_heap_hi - returns the address of the last heap byte.
 */
void *mem_heap_hi(void) { return (void *)(mem_brk - 1); }

/*
 * mem_heapsize() - returns the heap size in bytes
 */
size_t mem_heapsize(void) { return (size_t)(mem_brk - mem_start_brk); }

/*
 * mem_pagesize() - returns the page size of the system
 */
size_t mem_pagesize(void) { return (size_t)getpagesize(); }
