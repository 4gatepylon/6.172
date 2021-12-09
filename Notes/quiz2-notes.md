# Memory Models
Sequantial consistency: behaves as if the instructions of all processors were interleaved in some way but did act in sequence. Creates a "global linear order" of instructions. Loads of `X` must load the latest value to be stored in `X` in that global linear order. Memory states are only consistent if there is a valid linar order that yields it.

Peterson's algorithm:
```
Initialization:
b_wants = False, a_wants = False
turn = Alice or Bob, either is fine
```
```
Bob:
b_wants = True
turn = Alice
while (a_wants && turn == Alice) wait
do_your_thing(...)
b_wants = False
```
```
Alice:
a_wants = True
turn = Bob
while (b_wants && turn == Bob) wait
do_your_thing(...)
a_wants = False
```

Starvation freedom: while one processor wants to execute, the other can't execute twice. Peterson's algorithm guarantees it.

## Relaxed Memory Consistency
Both hardware and compilers may re-order instructions to, say, get higher instruction-level parallelism (i.e. in the pipeline).

Loads can stall the processor until satisfied because other computation depends on them.

There is a store buffer since the processor issues stores faster than IO network can handle them. Sometimes loads can read from this buffer instead. They can also read from the IO network instead, crowding out the stores. Thus, a **load can bypass a store to a different address**.

**x86-64** has the following convention **Locally**
- A: `Loads` are NOT reordered with other `Loads`
  - intra-load order is kept
- B: `Stores` are NOT reordered with other `Stores`
  - intra-store order is kept
- C: `Stores` are NOT reordered with prior `Loads`
  - stores do not take priority, loads do
- D: A `Load` may be reordered with a previous `Store` to a different location, but NOT to the same location
  - loads take priority, but within a processor for a single variable the order of its stores and loads should be kept
- E: No loads or stores can be re-ordered with `Lock` instructions (i.e. these form fences of a sort)

And the following convention **Globally**
- F: Stores to the same location obey a global total order
- G: `Lock` instructions respect a global total order
- H: Memory preserves "transitive visibility" by which they claim to mean causality.

They seem to claim that an invalid swap is valid. I don't really understand it. It's around `40:00` in the panopto video. Not sure how it's not the case that F follows from `B` across variables. I guess if you fix the variable the loads also join this global total order, since for any two loads and stores in a processor's code, they cannot swap if they are to the same variable (`load, load` by A, `store store` by B, `load, store` by C, and `store, load` by D). Thus, their relative ordering is the same which means that after re-ordering and interleaved, you have the same properties as before. NOTE, however, that this means you need to fix the variable (per processor) you are looking at, which ignores the fact that another processor might be doing something for some other variable as well which will be unintuitive.

Importantly, note that this is orthogonal to whatever the compiler does.

Peterson's algorithm breaks here because the load inside the while loop could run above the store (because it's to the opposite "wants" value).

You can ensure memory consistency with memory fences (cost is same as L2 cache), but you also need to stop the compiler, for which you need to do a bunch of crap. Now you can use `atomic_load` and store instead of vanilla loads and stores (part of the problem is that the compiler might avoid fetching from memory at all).

A couple theorems state that:
- If you have `n` processors you will need at best, proportional to `n` memory to run a deadlock-free mutual exclusion algorithm with vanilla loads ad stores (like Peterson's).
- Any `n` thread deadlock free mutual exclusion algorithm must use a memory fence or atomic read-modify-write like a compare and swap.

# Compare and Swap (CAS)
You can make deadlock-free algorithm by implementing a global lock with CAS (i.e. spin while it returns false and you are trying to set it to "locked") then unlock by setting to unlocked. Check whether it's equal to "unlocked" (compare to "unlocked," swap with "locked").

Example with the for loop. A lock would be bad especially if the OS decided to do a context switch since other processors would still need to wait.

NOTE that CAS operates with pointers. You give it a __pointer__ and two values (to compare and swap the value at that pointer to). That's how you can modify data structures.

Stack with compare and swap example (just check the head).

Often people have a short-circuit that checks whether the value of the object changed before CAS because if a lot of processors are trying to run CAS on the same location, you will get very high cache contention (since it wants to read, but the other guy is writing, and the other guy is reading, etcetera).

# ABA Problem
Example with a stack and CAS: thread one reads the second element and gets ready to pop the first element, but then thread two pops two elements and pushes back the first element pointing to the third. If the CAS only checks for pointer equality then it will pop and point head to the old second element (but the current second element is the third element). The second element might get freed (or whatever).

The only way to check is to somehow atomic read the second element on the store in the CAS (i.e. transactional memory: blocks of code as atomic) or to check other things (like an ID/version number). If you use a version number I think you need to make sure to modify the pointer at the same time (i.e. in the same CAS with a struct) since otherwise CASes might be interleaved. I think it would be **nice to have CAS which reads from location `x` and compares with value `X` and writes `Y` to location `y` if that is the case**.

# Cilk Runtime System
Work-first principle: optimize for work (serial performance) first.

Work-stealing: when a processor runs out of work it steals from a random other processor's stack (i.e. that processor is working at the bottom).

Cactus stack: like a stack but branches out like a cactus. Obeys C's rules for pointers (cannot pass up the stack).

Note that thiefs steal above a certain point in the stack, so if two workers need to sync, the worker which first arrives cannot stall because it has nothing to do above that (because it was stolen).

Compiler vs. Runtime libraries. The compiler does injection and handles fast paths and lightweight data structures (this I do not totally understand... maybe it's injecting them). The runtime handles heavier data structures, slow paths (i.e. steals) and more. Remember by the work first principle that steals are not optimized for (ideally you should not be stealing very often).

## Details
It uses four main data structures: a deqeue (which is basically a stack of pointers that points to the cactus stack), the cactus stack which is comprised of stack frames, and full-stack frames. The stack frames represent __spawning__ functions and their contexts. The full frame tree represents function instances that have been stolen. I'm not sure exactly what the regular stack frames hold (probably variables and whatnot), but the full-stack frames store at least a join counter, pointers to the corresponding stack frames in the cactus stack, and references to parent and children full frames. Every time a steal happens a new frame of these is made for the original (whose top has been stolen) and the thief (who is pointed to, because the person who has been stolen from will return to the thief, since they also have computation that comes prior). The thief's full frame is a "copy" of the original full-frame so to speak.

So basically:
- Use deqeue to keep track of your local stack view of the cactus stack
- Use cactus stack to keep track of a global stack (variables, etcetera)
- Use full frames to keep track of synchronization by keeping sync counters

Remember that if your sync does not complete the sync then you just go steal elsewhere. Otherwise, you will continue up the stack. Never blocks.

It uses `setjump` and `longjump` to resume computation from a point. That should only happen if you are stealing (I think).

Full frames that have outstanding child frames are suspended.

### Stealing
Some coordination is required during steals to avoid everyone trying to steal the same thing. Cilk uses a mutex with each dequeue (i.e. global to the deque/worker) to still from it. They use `THE` (tail head exception) protocol to do this. Only the thief ALWAYS locks (the worker only locks if something goes wrong because of the work-first princple: most of the work is done by workers). They have the nested checks because even if the thief aborts, the head might be equal to the tail (I think: I couldn't come up with a better reason or scenario where it was necessary).

# Leiserchess Algorithms
TODO!

# Garbage collection
Mark and Sweep: use BFS from root to find reachable objects. Mark marks all objects reachable and sweep frees those that were not. This finds and deals with cycles, but does not deal well with fragmentation.

Stop and Copy: when the space is full copy it to a new space such that there is no fragmentation. Do not copy things that are not live. We know if it's live again through BFS I think.

Reference counts: just keep track of how many references there are to it: does not deal well with cycles.

# TLB
A page table stores the mapping from virtual addresses to physical addresses. If the address requested is not in a cache it needs to be gotten from memory. First we check if we know where the address is in the TLB (since apparently using the page table is expensive). In that case we simple return the address. Otherwise, we need to search the page table. If we find it then we get that address from there. If we do not, then we need to see if we can find it on disk or not.

Pages are contiguous sections of memory with a fixed length. Frames are these pages, but in physical memory. Usually, the page in the virtual memory matches an entire page in the physical memory (I think).