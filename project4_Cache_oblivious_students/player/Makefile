CC := clang
TARGET := leiserchess

SRC := leiserchess.c util.c tt.c fen.c move_gen.c search.c eval.c end_game.c
OBJ := $(SRC:.c=.o)
DEP := $(OBJ:%.o=%.d)

UNAME := $(shell uname)
LOCAL := 0
DEBUG := 0
FLTO := 1

COMMONFLAGS := -Wall -Werror -Wextra
CFLAGS := $(COMMONFLAGS) -std=gnu99 -g
LDFLAGS := $(COMMONFLAGS) -lm -ldl

# Unit testing framework
UTHDR := unittest.h
UTGEN := unittest_gen.pl
ifeq ($(UNIT_TEST), 1)
  SRC += unittest_runner.c
  OBJ += unittest_runner.o
  DEP += unittest_runner.d
  CFLAGS += -DUNIT_TEST
  UTFLAGS += -t
endif

# Implementation testing with no non-determinism
ifeq ($(DETERMINISM), 1)
  CFLAGS += -DDETERMINISM
endif

# Consistency checking framework
# Adds flags to the UCI, little to no
# overhead change if not enabled/used via
# UCI but compiled in
# Disable with PEDANTIC=1 for final submission
CTHDR := consistencytest.h
CTGEN := consistencytest_gen.pl
ifeq ($(PEDANTIC), 1)
  CFLAGS += -DPEDANTIC
endif

ifeq ($(PARALLEL),1)
	CFLAGS += -DPARALLEL -fopencilk
	LDFLAGS += -fopencilk
endif

ifeq ($(UNAME),Darwin)
	CFLAGS += -DMACPORT -D__MACH__
endif

# for Cilksan and Cilkscale
ifeq ($(CILKSAN),1)
	CFLAGS += -fsanitize=cilk
	LDFLAGS += -fsanitize=cilk
else ifeq ($(CILKSCALE),1)
	CFLAGS += -fcilktool=cilkscale
	LDFLAGS += -fcilktool=cilkscale
endif

ifeq ($(DEBUG),1)
	CFLAGS += -O0 -DDEBUG
else
	CFLAGS += -O3 -DNDEBUG
endif

ifeq ($(FLTO),1)
	ifneq ($(UNAME),Darwin)
		CFLAGS += -flto
		LDFLAGS += -flto
	endif
endif

# DO NOT MODIFY THE ARCHITECTURES
ifeq ($(LOCAL),0)
	# You will be graded on haswell.
	CFLAGS += -march=haswell
else
	CFLAGS += -march=x86-64
endif

# First target is default
default: print_local_warning $(TARGET) ;

ifeq ($(LOCAL),0)
print_local_warning: ;
else
print_local_warning:
	@printf "\033[01;33mBE ADVISED: You have selected to build for your native architecture. This might be different than Haswell, which the AWS grading machines use.\033[00m\n"
	@printf "\033[01;33mUnless you have a good reason, unset the LOCAL flag or use LOCAL=0 before getting performance numbers on AWS.\033[00m\n"
endif

# Link the leiserchess binary
$(TARGET): $(OBJ)
	$(CC) $(LDFLAGS) $^ -o $@

%.o: %.c Makefile $(UTHDR) $(CTHDR)
	$(CC) $(CFLAGS) -MMD -c $< -o $@

$(UTHDR): $(UTGEN)
	./$(UTGEN) $(UTFLAGS)

$(CTHDR): $(CTGEN)
	./$(CTGEN)

-include $(DEP)

.PHONY: default format clean print_local_warning
clean:
	rm -f *.o *.d* *~ $(TARGET) $(UTHDR) $(CTHDR)

format:
	clang-format -i --style=file *.c *.h

