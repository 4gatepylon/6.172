// Copyright (c) 2012 MIT License by 6.172 Staff

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define q(seq) ""#seq""
#define p(type) printf("size of %s : %zu bytes \n", q(type), sizeof(type))
#define p_star(type) p(type); p(type*) 
#define p_addr(name) p(name); p(&name)

int main() {
  // Please print the sizes of the following types:
  // int, short, long, char, float, double, unsigned int, long long
  // uint8_t, uint16_t, uint32_t, and uint64_t, uint_fast8_t,
  // uint_fast16_t, uintmax_t, intmax_t, __int128, and student
  p_star(uint8_t);
  p_star(uint16_t);
  p_star(uint32_t);
  p_star(uint64_t);
  p_star(uint_fast8_t);
  p_star(uint_fast16_t);
  p_star(uintmax_t);
  p_star(intmax_t);
  p_star(__int128);

  p_star(int);
  p_star(short);
  p_star(long);
  p_star(char);
  p_star(float);
  p_star(double);
  p_star(unsigned int);
  p_star(long long);



  // Here's how to show the size of one type. See if you can define a macro
  // to avoid copy pasting this code.
  // printf("size of %s : %zu bytes \n", "int", sizeof(int));
  // e.g. PRINT_SIZE("int", int);
  //      PRINT_SIZE("short", short);

  // Alternatively, you can use stringification
  // (https://gcc.gnu.org/onlinedocs/gcc-4.8.5/cpp/Stringification.html) so that
  // you can write
  // e.g. PRINT_SIZE(int);
  //      PRINT_SIZE(short);

  // Composite types have sizes too.
  typedef struct {
    int id;
    int year;
  } student;

  student you;
  you.id = 12345;
  you.year = 4;


  // Array declaration. Use your macro to print the size of this.
  int x[5];
  p_addr(x);

  // You can just use your macro here instead: PRINT_SIZE("student", you);
  // printf("size of %s : %zu bytes \n", "student", sizeof(you));
  p_star(student);
  p_addr(you);

  return 0;
}
