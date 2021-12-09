LOCAL := 0

CC := clang
CFLAGS := -Wall -O1 -g -fopencilk
LDFLAGS := -fopencilk -ldl -lpthread

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


all: hashtable-mt hashtable-serial undef


hashtable-mt: hashtable-mt.c hashlock.c common.h
	$(CC) -o $@ $(DBG) $(CFLAGS) hashtable-mt.c hashlock.c $(LDFLAGS)

hashtable-mt100: ./hashtable-mt
	bash -c "for((i=0;i<100;i++)) do ./hashtable-mt; done"


clean: 
	@-rm -f undef hashtable-mt hashtable-serial


undef-compare: 
	make CFLAGS=-O3 clean undef; ./undef
	make CFLAGS=-O1 clean undef; ./undef

undef-noaslr: ./undef
	setarch x86_64 -R ./undef
	setarch x86_64 -R ./undef


hashtable-serial: hashtable-serial.c
	$(CC) -o $@ $(DBG) $(CFLAGS) hashtable-serial.c $(LDFLAGS)

hashtable-serial100: ./hashtable-serial
	bash -c "for((i=0;i<100;i++)) do ./hashtable-serial; done"

# XXX modify this target so that 1000 runs all succeed
hashtable-serial-good: ./hashtable-serial
	bash -c "for((i=0;i<100;i++)) do ./hashtable-serial; done"
# XXX modify this target so the program always fails
hashtable-serial-bad: ./hashtable-serial
	./hashtable-serial


%: %.c
	$(CC) -o $@ $(DBG) $(CFLAGS) $^ $(LDFLAGS)
