# Some Ideas

### Testing memset over cilk_for and setting the values manually

I found I was able to get 5 tiers by using a cilk_for to zero my colored array instead of using
memset.


### Allocating outside of the loop

This may have made it slower but that may be due to the fact that I have to zero the image.