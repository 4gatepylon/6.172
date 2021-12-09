/**
 * Copyright (c) 2020 MIT License by 6.172 Staff
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

/**
 * allocator.h
 *
 * You may include macros, inline helper function definitions, and helper
 * function prototypes here instead of in allocator.c, especially if you like to
 * test them in allocator_test.c.
 **/

#ifndef MM_ALLOCATOR_H
#define MM_ALLOCATOR_H

// All blocks must have a specified minimum alignment.
// The alignment requirement (from config.h) is >= 8 bytes.
#ifndef ALIGNMENT
#define ALIGNMENT 8
#endif

// Rounds up to the nearest multiple of ALIGNMENT.
#define ALIGN(size) (((size) + (ALIGNMENT - 1)) & ~(ALIGNMENT - 1))

// The smallest aligned size that will hold a size_t value.
#define SIZE_T_SIZE (ALIGN(sizeof(size_t)))

#endif  // MM_ALLOCATOR_H

// Original design:

// Our strategy is to create blocks of size the lowest power of two above header_size + requested size, meaning that at most
// we are wasting half our memory. We return an aligned pointer to the first byte after the header (header_size is aligned).
// The header stores the power of two (i.e. 1,2,3, ..., 31) which we use to get the size of the entire block. Thus it is 8
// bytes since 32 = 2^5. We do not accept any blocks larger than 2^30 (excluding header) or smaller than 8 (excluding header).

// We will have helper functions
// (1) "Request" 2^k sized bin, which will either
//   (a) return the head of that bin and set it to next or (b) return Cascade(2^k)
// (2) "Cascade" will look for the first bin above 2^k that has a non-NULL head and if it
//   (a) finds it, then it will split it into a half, a quarter, and so on until two instances of 2^k (one returned, one is head)
//   or (b) doesn't find it, in which case it sbrks size 2^k and returns it
// (3) inlined "Pow2Ceil" which returns the log of the lowest power of two above a value

// Here is what our primarily functions will do
// (1) "init" will set all bins to point to NULL and return zero
// (2) "free" will simply get the power of two in the header as the index, and set that as the head in that bin
// (3) "realloc" will either
//   (a) do nothing if the requested size + header size < 2^k for the k in the header
//   or (b) return Request(Pow2Ceil(requested size + header size)) and set the given block as its bin's head
//   (copying over data up to the requested size)
// (4) "malloc" will return Request(Pow2Ceil(requested_size + header_size))

// NOTE
// We will want to improve/consider doing
// 1. Dealing with powers of 2 (potentially drop the header? we can use alignment for that, but remembering the power is harder)
// 2. Coalescing of some kind
//   (for example we might store four pointers inside each block such that two are for forward/backwards on the free-list
//    and two are for forwards/backwards spatially, and then we expand spatially as much as possibe, or some other amount
//    every time we free and use the two free-list pointers to remove and insert blocks from the corresponding bins)
// 3. Smarter initialization (potentially)
//   (one idea we had here was to initialize a second freelist such that it does NOT do cascading; for this freelist
//   every time we deplete it we check the original freelist, if both are empty then we double the size of this freelist;
//   the core feature is that this freelist has the bins such that the bins' elements are in consecutive memory locations,
//   so we can figure out the length from the location of the pointer; if it's in none of the bins then it goes into the
//   original freelist; note that this first freelist set of bins would probably be smaller (since cascading doesn't work)
//   and the ranges would double upon depletion or sufficient usage: it targets workloads like 1000's of calls to a single small
//   power like 32)
// 4. Accomodating sizes that are not powers of two, this will require an ingenious cascade algorithm. We would then use
//   the actual sizes instead of their logs (i.e. to take two to the power of) for the binned freelists.
// 5. On realloc, if reallocating to a very small size, make sure to cascade.

// More exotic ideas include:
// 1. more or less balanced binary search tree of blocks (by randomizing BSTs maybe it can be good enough)
// 2. sorting online with something like bubble sort or insertion sort; bubble sort may be compelling since
//   it's easy to execute as we search for a good fit for our block. This would help best-fit/good-fit, but
//   it's also unclear whether having that many if statements may be bad.
// 3. Encoding multiple pointers by storing, not pointers, but instead OFFSETS using some constant "base block" size.
//   With this type of technique we can implement skip lists and other fancy data structures. Bit fields would be helpful here.


// New Design (flexibins):

// Store actual sizes in the header. Allocate exactly as necessary if we are under a power of two plus halfway to the
// next one, else allocate the next power of two. Potentially add a little bit of padding. Potentially, just allocate the
// exact amount every time (we'll start with this latter one and then heuristically tune).

// Here is what our primarily functions will do
// (1) "init" will set all bins to point to NULL and return zero; then it will sbrk if necessary to 8 byte align.
// (2) "free" will simply get the log floor of the size in the header, and then insert it in that bin
// (3) "realloc" will either
//   (a) do nothing if the 2^(log_floor(size) - 1) < requested size + header size < size for the size in the header
//   or (b) return the beginning, then cascade down the other "half" if it's smaller than the lower bound in the previous equation,
//   or (c) return Request(requested_size + header_size) and set the given block as its bin's head
//   (copying over data up to the requested size)
// (4) "malloc" will return Request(requested_size + header_size)

// (1) "Request" size, which will either
//   (a) return the first element in that bin that is big enough and remove from the free-list or 
//   (b) return Cascade(requested size + header size)
// (2) "Cascade" will look for the first bin above 2^k that has a non-NULL head and if it
//   (a) finds it, then it will split it into header size + requested size and the rest, returning the former and
//   inserting the latter in the correct bin, and if it (b) doesn't find it then it wills sbrk the amount
// (3) inlined "log_floor" which returns the highest log of a power of 2 below the size given

// NOTE: all sbrk amounts will be 8-byte aligned!
// Potential optimizations to flexibins: bubble sort online, doubly-linked-lists with start and end pointers,
// allocating padding (i.e. to powers of two or midpoints between them) or a constant fraction.

// MITPOSSE TEST SCENARIO
/*
Look in our writeup for more details!

Here is an example trace to explain our program’s behavior. Say we try to malloc 8 bytes. 
Then, our program will first increase the size to the minimum allowable of 16 bytes (because it needs to store a 
doubly linked-list inside). Then it will align it (in this case, keeping 16 bytes). 
Then (assuming our binned free lists are empty) our program will find that there is nothing 
in any bin and use mem_sbrk(24) to allocate a new block with an 8-byte header, inserting the size 
“16” into that header (a uint64_t) and returning the pointer at the end of the header. 
Assume then they want to realloc this to 35 bytes. 35 is between 32 and 64, so it would go into 
bin 5 (as 32 is 25). However, the block the user is giving us is too small, so our program would try to 
find a replacement. Since the bins are still empty, it would find nothing and sbrk. However, it would check 
if the block given was the last block (by checking the header’s size and then adding that to the
pointer and seeing if this was equal to mem_heap_hi()). Since in this case it is the last block, 
it would simply mem_sbrk() the remaining 19 bytes necessary to take 16 to 35 (from the point of 
view of the user. However, this would first be aligned to 24, so the program would mem_sbrk(24) and 
update the header to store the 8-byte aligned size of the block, 16 + 24 = 40.
From this scenario, note how we do not count the header size in the header. Note how the header 
stores the value of the block and not the size as requested by the user. The block’s actual size is 
obviously guaranteed to be larger than the user’s requested size. Note that bin indices are ranges 
for the floors of the logarithms of the sizes of blocks including their headers (not just the body).
Say we then realloc to a smaller size, say 24. Nothing is done here because the size is smaller.
Say we then free this block. Our program would find the total block size 40 + 8 = 48. Then it would 
find the floor of the logarithm of this value: in this case 5. Thus, it would insert it onto the head 
of the doubly linked-list in bin 5.
Say that subsequently we malloc and then free a bunch of blocks that all go into bin 5. Now we want 
to malloc something of size 32 (that is to say, at least size 32). Our program will first look into 
that list and find that it is non-empty. It will traverse the list and use a heuristic to see if any 
block it finds is a good fit. A good fit in our heuristic is defined such that the block which is being 
tested is not larger than the desired size plus halfway towards the next power of two. If no such block 
is found, but a block which is valid (between 31 and 64, exclusive) is found, we will return it at the end 
of the search (otherwise we’d have returned that “good fit” block earlier).
Say that after that we wish to malloc a block of size 15. This would be increased and aligned to 16. 
We would find an empty bin (bin 4) and so we would search upwards for a bin with elements in it. We 
would find bin 5 with a long linked-list. In this bin we would pop the head (assume it has 56 elements 
including the header, so 48 without the header). We would, noting that we only need 24 elements, “split” 
it (also called “cascade” in our code) into 24 elements in the beginning (overriding the header) and 32 
elements in the back. The 32 elements we would find to be sufficiently large (larger than, or equal to, 24) 
so we would write to their first 8 bytes a header saying “24” (since 32 bytes for a block in total minus 8 bytes 
for its header is 24 bytes of body) and insert that into bin 5 since 5 is the 
floor of the logarithm of 32. That way we can reuse the “leftover” of the block we just fetched. Subsequently, we’d return that updated 
first 15-byte block (plus 8 bytes of header for a total of 24 bytes, though, of course the user can only see 16 of them) to the user.

*/