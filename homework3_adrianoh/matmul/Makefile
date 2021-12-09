# Set this to 1 if you are compiling for your native machine
# as opposed to a Haswell compatible build for awsrun
LOCAL := 0

CC := clang

TARGETS = matmul

EXTRA_CFLAGS ?=
CFLAGS := -Wall -std=gnu11

ifneq ($(NODBGSYM),1)
  CFLAGS += -g
endif

ifeq ($(DEBUG),1)
  CFLAGS += -O0 -fsanitize=address
else
  CFLAGS += -O3 -DNDEBUG
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

ifeq ($(VECTORIZE),1)
  ifneq ($(NODBGSYM),1)
    CFLAGS += -Rpass=loop-vectorize -Rpass-missed=loop-vectorize
  endif
else
  CFLAGS += -fno-vectorize
endif

ifeq ($(ASSEMBLE),1)
  TARGETS += matmul.s
endif

ifeq ($(LLVMIR),1)
  TARGETS += matmul.ll
endif

ifeq ($(AVX2),1)
  CFLAGS += -mavx2
else
  CFLAGS +=  -mno-avx
endif

ifeq ($(FMA),1)
  CFLAGS += -mfma
endif

CFLAGS += $(EXTRA_CFLAGS)

LDFLAGS := -lrt -fsanitize=address

# You shouldn't need to touch this.  This keeps track of whether or
# not you've changed CFLAGS.
OLD_CFLAGS := $(shell cat .cflags 2> /dev/null)
ifneq ($(CFLAGS),$(OLD_CFLAGS))
.cflags:
	@echo "$(CFLAGS)" > .cflags
endif


all: $(TARGETS)

%.o: %.c .cflags
	$(CC) $(CFLAGS) -c $<

%.s : %.c .cflags
	$(CC) $(CFLAGS) -S -c $<

%.ll : %.c .cflags
	$(CC) $(CFLAGS) -S -emit-llvm -c $<

%: %.o
	$(CC) -o $@ $^ $(LDFLAGS)

clean::
	rm -f $(TARGETS) $(patsubst %,%.o,$(TARGETS)) $(patsubst %,%.s,$(TARGETS)) $(patsubst %,%.ll,$(TARGETS)) .cflags perf.data */perf.data
