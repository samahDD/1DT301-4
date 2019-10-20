#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "my_math.h"

/********************************
 * Example Lecture 4 - Page 27
 *******************************/
float my_square(float f)
{
	return f*f;
}

void my_square2(float f, float *ret)
{
	*ret = f*f;
}

int main()
{
float result = 0;

	my_square2(3, &result);

/********************************
 * Example Lecture 4 - Page 28
 *******************************/
unsigned char b = 0x82;

// Get the low nibble
unsigned char res = b & 0x0F;
	printf("Low nibble=%x\n", res);

// Get the high nibble
	res = (b & 0xF0) >> 4;
	printf("High nibble=%x\n", res);

// Set 0x4 as a new low nibble
	res = (b & 0xF0) + 0x4;
	printf("%x\n", res);

// Set 0x5 as a new high nibble
	unsigned char newHighNibble = 5;
	res = (b & 0x0F) + (newHighNibble << 4);
	printf("%x\n", res);

/********************************
 * Example Lecture 4 - Page 29
 * Also, see files
 * 	my_math.h
 * 	my_math.c
 * and line 5 above.
 *******************************/
	int j = 2, k = 3;
	printf("%i+%i=%i\n", j, k, add(j, k));
	printf("%i-%i=%i\n", j, k, subtract(j, k));
	return EXIT_SUCCESS;
}








