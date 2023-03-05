#include <stdio.h>

int main()
{
	//zadanie 1 - triv
	//zadanie 2 - triv
	//zadanie 3 - IPAD
	//zadanie 4
	int x, y;
	scanf("%i %i", &x, &y);
	//x * 2^y
	int wynik = x << y;
	printf("%i\n", wynik);

	wynik = x >> y;
	printf("%i\n", wynik);

	wynik = x & ((1 << y) - 1);
	printf("%i\n", wynik);

	// int p = 1 << y;
	// int x2 = x - 1;
	// x2 = (x - 1) >> y;
	// x = x >> y;
	// z = (1 & )

	wynik = (x >> y) + (1 & (((1 >> y) & x) ^ (1 & ( (x - 1) >> y))));//moze sie przepelnic dla y = 0 i x = max
	printf("%i\n", wynik);

	//zadanie 5
	//negacja wszystkich bitów i tyle (triche to jak ja myślałam że to zrobić)

	//zadanie 6 - IPAD (działa?)

	//zadanie 7

	//zadanie 8

	//zadanie 9:
	//0 - NULL (koniec?)
	//4 - end of transmission
	//7 - bell (informacja ze cos zostanie nadane)
	//10 - nowa linia
	//12 - nowa strona

	//zadanie 10 - np na chinski jest za mało (4000 znaków a ascii moze max 265)
	//zwykłe literki jak ascii
	//ę - 
	//
	//zadan zrobić nie 	

}