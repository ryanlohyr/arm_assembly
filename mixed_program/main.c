#include <stdio.h>

// Declare the assembly functions
extern int add_numbers(int a, int b);
extern int multiply_numbers(int a, int b);

int main() {
    int x = 10;
    int y = 5;
    
    printf("Calling assembly functions from C:\n");
    printf("x = %d, y = %d\n", x, y);
    
    // Call assembly functions
    int sum = add_numbers(x, y);
    int product = multiply_numbers(x, y);
    
    printf("add_numbers(%d, %d) = %d\n", x, y, sum);
    printf("multiply_numbers(%d, %d) = %d\n", x, y, product);
    
    return 0;
}
