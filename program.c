#include <stdio.h>
#include <stdint.h>
#define SIZE 16
int even_mult(uint16_t arr[SIZE][SIZE]) {
  uint16_t product = 1;
  uint16_t result = 1; // Using 16-bit to avoid overflow for demonstration
  // Computing the product of even numbers
  for (int i = 0; i < SIZE; i++) {
    for (int j = 0; j < SIZE; j++) {
      if (arr[i][j] % 2 == 0) {
        product *= arr[i][j];
        }
      }
    }
  result = product;
  return result;
}
