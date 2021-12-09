# The sources we're building
HEADERS = $(wildcard *.h)
PRODUCT_SOURCES = main.c render.c simulate.c utils/helper.c utils/performance_tester.c
CORRECTNESS_PRODUCT_SOURCES = utils/ref_tester.c

# What we're building
PRODUCT_OBJECTS = $(PRODUCT_SOURCES:.c=.o)
CORRECTNESS_PRODUCT_OBJECTS = $(CORRECTNESS_PRODUCT_SOURCES:.c=.o)
PRODUCT = main
PROFILE_PRODUCT = $(PRODUCT:%=%.prof) #the product, instrumented for gprof
SCALE_PRODUCT = $(PRODUCT)-scale #product for work-span analysis
BENCH_PRODUCT = $(PRODUCT)-benchmark #product for scalability benchmarking
CORRECTNESS_PRODUCT = ref_test #product for generating correctness stats

# What we're building with
CC = clang
CFLAGS = -std=gnu11 -Wall -g -fopencilk -mavx2 -flto
LDFLAGS = -lrt -lm -ldl -lGL -lGLU -lglut -fopencilk -flto

CFLAGS_ASAN := -O3 -g -fsanitize=address

# We add -lprofiler to enable google perf, install google perf with
# `sudo apt-get install -y google-perftools libgoogle-perftools-dev` as per HW 2

# Usage Per HW2:
# To use pprof, you must add `-lprofiler` to your program’s LDFLAGSin the Makefile 
# (remember toremove it for performance benchmarking). When you’ve compiled your program with this flag,  
# you can dump profile data to a file like `pprof-data.out` like so:
# `CPUPROFILE=pprof-data.out ./<binary> <args>` Then, you can use pprof to visualize the output 
# as graph in a GUI: `google-pprof -gv ./<binary> pprof-data.out`.
# See https://gperftools.github.io/gperftools/cpuprofile.html for more information on how to usepprof.
ifeq ($(GOOGLE_PERF), 1)
  LDFLAGS += -lprofiler
endif

ifeq ($(CILKSAN),1)
 CFLAGS += -fsanitize=cilk -DCILKSAN=1
 LDFLAGS += -fsanitize=cilk
else ifeq ($(CILKSCALE),1)
 CFLAGS += -fcilktool=cilkscale -DCILKSCALE=1
 LDFLAGS += -fcilktool=cilkscale
endif

ifeq ($(ASAN),1)
  CFLAGS := $(CFLAGS_ASAN) $(CFLAGS)
  LDFLAGS := $(LDFLAGS) -fsanitize=address
endif

# Determine which profile--debug or release--we should build against, and set
# CFLAGS appropriately.

ifeq ($(DEBUG),1)
  # We want debug mode.
  CFLAGS += -g -Og -gdwarf-3 -DDEBUG
else
  # We want release mode.
  ifeq ($(CILKSAN),1)
    CFLAGS += -O0 -DNDEBUG
  else
    CFLAGS += -O3 -DNDEBUG
  endif
endif


# By default, make the product.
all:		$(PRODUCT) $(CORRECTNESS_PRODUCT)

# How to build for profiling
prof:		$(PROFILE_PRODUCT)

# Product for work-span analysis
scale:		$(SCALE_PRODUCT)

# Additional product necessary for scalability benchmarking
bench:		$(BENCH_PRODUCT)

# How to clean up
clean:
	$(RM) $(PRODUCT) $(PROFILE_PRODUCT) $(CORRECTNESS_PRODUCT) $(SCALE_PRODUCT) $(BENCH_PRODUCT) *.o *.d *.out framesSimNew.txt framesSimOld.txt framesRenderNew.txt framesRenderOld.txt
	rm -f ./utils/*.o

# How to compile a C file
%.o:		%.c $(HEADERS)
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) -o $@ -c $<

# How to link the product
$(PRODUCT):	$(PRODUCT_OBJECTS)
	$(CC) $(LDFLAGS) $(EXTRA_LDFLAGS) -o $@ $(PRODUCT_OBJECTS)

# How to build the product, instrumented for profiling
$(PROFILE_PRODUCT): CFLAGS += -DPROFILE_BUILD -pg
$(PROFILE_PRODUCT): LDFLAGS += -pg
$(PROFILE_PRODUCT): $(PRODUCT_OBJECTS)
	$(CC)  $(PRODUCT_OBJECTS) $(LDFLAGS) $(EXTRA_LDFLAGS) -o $(PROFILE_PRODUCT)

$(SCALE_PRODUCT): CFLAGS += -fcilktool=cilkscale
$(SCALE_PRODUCT): LDFLAGS += -fcilktool=cilkscale
$(SCALE_PRODUCT): $(PRODUCT_OBJECTS)
	$(CC) $(PRODUCT_OBJECTS) $(LDFLAGS) $(EXTRA_LDFLAGS) -o $(SCALE_PRODUCT)

$(BENCH_PRODUCT): CFLAGS += -fcilktool=cilkscale-benchmark
$(BENCH_PRODUCT): LDFLAGS += -fcilktool=cilkscale-benchmark
$(BENCH_PRODUCT): $(PRODUCT_OBJECTS)
	$(CC) $(PRODUCT_OBJECTS) $(LDFLAGS) $(EXTRA_LDFLAGS) -o $(BENCH_PRODUCT)

$(CORRECTNESS_PRODUCT): $(CORRECTNESS_PRODUCT_OBJECTS)
	$(CC) $(CORRECTNESS_PRODUCT_OBJECTS) $(LDFLAGS) $(EXTRA_LDFGLAGS) -o $(CORRECTNESS_PRODUCT)
