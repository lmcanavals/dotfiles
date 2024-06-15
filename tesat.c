#include <stdio.h>
#include <stdlib.h>

int main() {
  char *tape = (char *)malloc(1000);
  char *ptr = tape + (500);


  free(tape);

  return 0;
}
