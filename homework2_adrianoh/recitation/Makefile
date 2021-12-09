# Set this to 1 if you are compiling for your native machine
# as opposed to a Haswell compatible build for awsrun
LOCAL := 0

CC := clang

ifeq ($(DEBUG),1)
	CFLAGS := -Wall -O0 -g
else
	CFLAGS := -Wall -O3 -ggdb -DNDEBUG 
endif

CFLAGS_AWSRUN := -march=haswell
CFLAGS_LOCAL := -march=native

ifeq ($(LOCAL), 0)
	CFLAGS := $(CFLAGS_AWSRUN) $(CFLAGS)
else
	CFLAGS := $(CFLAGS_LOCAL) $(CFLAGS)
endif

ifeq ($(LOCAL), 1)
$(info BE ADVISED: You have selected to build for your native architecture. This might be incompatible with awsrun machines. Make sure to unset the LOCAL flag or use LOCAL=0 before running on awsrun.)
endif

LDFLAGS := -lrt

all: isort sum

isort.o: isort.c 
	$(CC) $(CFLAGS) -c isort.c 

qsort.o: qsort.c 
	$(CC) $(CFLAGS) -c qsort.c 

isort: isort.o qsort.o
	$(CC) -o isort isort.o qsort.o $(LDFLAGS)

sum.o: sum.c 
	$(CC) $(CFLAGS) -c sum.c 

sum: sum.o
	$(CC) -o sum sum.o $(LDFLAGS)

clean:
	rm -f isort sum *.o *.gcda *.gcno *.gcov perf.data */perf.data cachegrind.out.*
