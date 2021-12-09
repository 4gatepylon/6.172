CC := clang
CFLAGS := -Wall -O3 -g -gdwarf-3 -fopencilk -march=x86-64
LDFLAGS := -fopencilk -ldl -lm -lstdc++

DEPS := $(DEPS) ../fasttime.h ../common.mk Makefile

ifeq ($(CILKSAN),1)
	CFLAGS += -fsanitize=cilk -DCILKSAN=1
	LDFLAGS += -fsanitize=cilk
else ifeq ($(CILKSCALE),1)
	CFLAGS += -fcilktool=cilkscale -DCILKSCALE=1
	LDFLAGS += -fcilktool=cilkscale
endif

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SRC) $(DEPS)
	$(CC) -o $@ $(CFLAGS) $(SRC) $(LDFLAGS)

clean:
	rm -f $(TARGET)
