#include <stdint.h>
#include <stdio.h>
//ZADANIE 1

/*
nie, dla i = -2^31 jest ujemna, wiec nie a x - 1 przeskakuje i jest dodatnia
tak
x = 2^16 - 1
nie
x = -2^31
x = 0 (nigdy?)
== porównuje wartosci czy bity???
nie mam zielonego pojecia
*/

//ZADANIE 2
int swap(int x, int y)
{
	x = x ^ y;
	y = y ^ x;
	x = x ^ y;
	printf("%i, %i", x, y);
}

//ZADANIE 3
/*jesli x + y to overflow / underflow to prawda, jak nie to falsz*/



int main(){
	// int x = -100;
	// printf("%u", (uint32_t)x);
	int x, y;
	scanf("%i %i", &x, &y);
	swap(x, y);
}