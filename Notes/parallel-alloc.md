# Allocation
Recall `malloc` and `free`.

`memalign` allows you to allocate memory that is aligned to a multiple of 2. You might use this to make sure you have no false sharing (by getting your own cache block).

# mmap
`mmap` is a system call that allows you to allocate virtual memory through "memory mapping." You tell it how many bytes (and whether you care where) whether to read/write, whether there is a file that should be backing it up, and an offset (I don't know what the offset is). The kernel finds a contiguous, unused region in the address space to do this.

You can use this syscall for tons of memory (i.e. a terabyte of memory) even if you have very litle. It's also lazy and will not actually allocate the page until you need it (it starts by pointing to a special "zero" page that will pagefault when you write to it).

Malloc is good because you can `free` (i.e. it tries to reuse as necessary). `malloc` is also a library function, so maybe it can be upgraded, or you can write your own, or whatever. Also, there is no context switch, while `mmap` is a syscall which does call a context switch, making it slow. Of course, if there is no memory at all, `malloc` does use `mmap`.

# Page Table and TLB
So the page table seems to tell you where to find pages in real memory (i.e. it tells you what "frame" and what "offset" inside the frame to go to). The TLB (translation lookaside buffer) is a buffer (suppoedly in hardware) of the most recent or common (or best to cache) page table entries for quick lookup.

# Cactus Stack
How do you share multiple stacks that have different suffixes? Heap-based stack? It's a bit slower... Moreover, it is not properly interoperable with legacy programs that do not use Cilk cactus stacks.

Instead, Cilk uses a pool of linear stacks.

__Theorem__ When the original program on one processor took stack space up to `S_1`, then on `P` processors, the stack taken in total `S_P`, is no more than `P * S_1`. This is because of Cilk's "busy leaves" property: each stack leaf always has a processor running on it. That means that at maximum `P` things are growing, and none can take longer than `S_1`.

# Matrix Multiplication example and space examples
Time and space complexity of matrix multiplication with breaking into quarters? Using busy leaves how can you use the bound from space with one processor to the space on `P` of them?

He gives the example of a tighter bound by looking at when the branching reaches the number of processors. Before that point, the size grows geometrically because copies are being made for the new processors. After that point, the size decreases geometrically since only `P` of those are being taken and the number is growing by a lot more. Thus, `O(that point)` is `O(the whole thing)`. Thus, you can sum the size of the leaves in big-O at that layer yielding you a much tighter bound (depending also on `P`).

# Allocator
Speed is the number of allocations and deallocations per second. You want to optimize speed for small blocks because small blocks are usually more frequent, but also because large blocks usually are used by more work (so it is better amortized). He calls this higher "churn."

User footprint is the most number of bytes (over time) a user had allocated but not freed. The allocator footprint is the maximum number of bytes over that time that the allocator used (i.e. the OS provided to it). These are, respectivelly, called `M` and `H`. The fragmentation is `F = H/M` (and space utilization is `1/F`), because you want low `H` to high `M` (with the minimum here being `1`).

He observes that `H` grows monotonically over time for many allocators. He notes that the fragmentation of binned free-lists is `O(logM)`

Lingo:
- Space Overhead: bookeeping space from the allocator
- Internal Fragmentation: fragmentation because it gives users sizes that are larger than they need
- External Fragmentation: fragmentation because after freeing it cannot make a bigger block with the free space (because it's not contiguous or whatever)
- Blowup: for parallel allocators this refers to the extra wasted space when compared to the serial version ("additional beyond what the serial would require")

## Strategy 1: Regular allocator with global lock (shared heap)
Blowup = 1.

Bad for lock contention. This is especially bad for small blocks, which we wanted to optimize for!

Slow (not parallel).

Scalability is some measure of how time grows (or should not grow) as you add more processors. This processor is not scalable.

## Strategy 2: Local Heap
`GOOD`: Fast. No synchronization. Scalable!

`BAD`: Blowup `infinite`. Seems like it suffers from `memory drift` which refers to the case where one processor keeps alllocating and another keeps freeing the same thing (if that's even allowed) which means one's guy's memory fills up and the other's is always empty and never reused.

## Strategy 3: Local Ownership
Each object is labeled for its owner. Freed objects are returned to their owners' heaps.

`GOOD`: Fast allocation and freeing of local objects. `BAD`: Freeing requires synchronization though which may not be great.

`OK`: `Blowup <= P`.

`GOOD`: It is resilient to false sharing.

# False Sharing
`x` and `y` are on the same cache line. Processor `P_1` writes to `x` but processor `P_2` writes to `y`. They do not share data, but the computer acts as if they do. This is bad because it slows down everything because of cache coherence. You can ping pong which is killer.

A program can induce false sharing by having different processes work on nearby objects.

You can try to mitigate by aligning or padding (say to cache blocks). Not ideal because of wasted space.

He gives a story of a database company where they put all the locks in a single array and a hero put a pad between the elements and it got way faster.

This can happen "actively" or "passively." The former is when the heap itself has data which is false sharing and the latter is when the allocated stuff is being used in one place then moved to another.

# Various allocators exist
Hoard, jemalloc, SuperMalloc.

We look at Hoard.

## Hoard
Each processor has a local heap which fetches superblocks from a globally locked heap. Small blocks are within the local heap and only every `S` bytes (the size of the superblock) do we need to access the global heap. By insuring (with an if statement: they can return superblocks) that the memory in usage is at least `min(memory in local heap - 2S, memory in local heap / 2)` they can ensure that the non-utilized stoage is at most `2S + M_i / 2` for `M_i` bytes used by that processor. Thus, we end up with a total maximum utilization of `O(S * P + M_total)` which is in total a blowup of `O((S * P)/M_total + 1)` which is good!

A student raised a question regarding what they did when they returned blocks to the objects inside. They do not know, it's unclear. Possbly, they just bank up a queue of frees and send them to the global heap eventually. Only once the block is totally free is it probably possible to send again to any processor.

# DRAM Antics
DRAM for whatever reason needs to read before it can modify and write. They added "streaming writes" to do that faster. I don't think that's relevant to us, but mainly it means that using Intel intrinsics you can speed up your DRAM accesses.