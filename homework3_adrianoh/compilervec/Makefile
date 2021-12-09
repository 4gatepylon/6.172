# Set this to 1 if you are compiling for your native machine
# as opposed to a Haswell compatible build for awsrun
LOCAL := 0

CC := clang

TARGETS = example1 example2 example3

EXTRA_CFLAGS ?=
CFLAGS := -Wall -std=gnu99

ifneq ($(NODBGSYM),1)
  CFLAGS += -g
endif

ifeq ($(DEBUG),1)
  CFLAGS += -O0
else
  CFLAGS += -O3
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

V ?= 1

ifeq ($(VECTORIZE),1)
  ifneq ($(NODBGSYM),1)
    CFLAGS += -Rpass=loop-vectorize -Rpass-missed=loop-vectorize
  endif
else
  CFLAGS += -fno-vectorize
endif

ifeq ($(ASSEMBLE),1)
  CFLAGS += -S
endif

ifeq ($(LLVMIR),1)
  CFLAGS += -S -emit-llvm
endif

ifeq ($(AVX2),1)
  CFLAGS += -mavx2
else
  CFLAGS +=  -mno-avx
endif

CFLAGS += $(OTHER_CFLAGS)

LDFLAGS := -lrt

# You shouldn't need to touch this.  This keeps track of whether or
# not you've changed CFLAGS.
OLD_CFLAGS := $(shell cat .cflags 2> /dev/null)
ifneq ($(CFLAGS),$(OLD_CFLAGS))
.cflags:
	@echo "$(CFLAGS)" > $@
endif


all: $(TARGETS:=.o)

%.o: %.c .cflags
	$(CC) $(CFLAGS) -c $<

%.lst: %.c .cflags
	$(CC) $(CFLAGS) -Wa,-aslh -c $< > $@

clean::
	rm -rf 
	rm -f $(patsub %,%.o,$(TARGETS)) $(patsubst %,%.s,$(TARGETS)) $(patsubst %,%.ll,$(TARGETS)) $(patsubst %,%.lst,$(TARGETS)) .cflags perf.data
