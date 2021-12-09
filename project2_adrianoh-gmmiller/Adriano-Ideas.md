IMPORTANT: please use perf to find the bottlenecks. I have a ton of cool ideas here, but it should be possible to just do perf to decide where to go. I don't think we'll have enough time to do everything.

# Some Ideas for Optimizing Render
- Find the endpoints for the circles' on each row and then just write pixels between (without needing to check)
- Use tensor (i.e. vector of images) with a divide a conquer approach to parallelize sphere drawing (i.e. 8 or 16 copies)
- Render in chunks for caching locality
- Project accel/displacement onto the plane/screen so that we can do easier math (for example, note how the raws to the balls make lines, so if you do this re-basis it will be the case that you can see the width of the image that needs to be drawn in O(1) by just measuring the ratio of distance from the eye to screen to that from eye to the ball; then you can find the displacements equally easily; this requires no projective math)
- Find boundaries in O(logN) by using binary search and then write in between without needing to check (if the projection is too hard or induces floating point woes)
- Find some way to short circuit chunks of the image to NOT write to, perhaps by breaking it into a larger grid. For example, some sort of quad tree like structure on the screen.

# Some Ideas for Optimizing Simulation
- nC2 Accel Calculations: `DONE`
- Parallelize Accel Calculations: `DONE`
- Bounding Boxes fast pass
- Create a 3D grid by splitting space into uin64_t size and use integer arithmetic for even faster pass
- Don't use both masses (i.e. don't calculate the force): `DONE`
- Make sure G and the masses are not re-calculated
- Improve sorting and/or data structures (HARD)
- Use a grid-type structure to try and minimize the number of collisions that need to be checked...
- There is no need to do any sort of k-d tree or even an oct-tree, we could just pick a random and low-granularity grid...

# Tech Debt Important
- Physics Use bounding boxes, and they better be pre-computed per frame (or alternative the three sorted arrays)

# Tech Debt less important
- Physics and render: sort bounding boxes instead of sphere locations (fight for this) (alternative is integer grid)
- Physics: avoid copying back the copies of the spheres, just swap the pointer that we use
- Physics: make sure everything is vectorized; fight for freedom to change the format of the data