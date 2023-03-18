#include <stdio.h>

int zadanie1(int x, int i, int k){//moze jest dobrze?
	// // //pierwsza wersja (z if-ami)
	// if(i == k) return x;
	
	// int p = (1 << i) & x;
	// int p2 = ~(1 << k);
	// x = (x & p2);//wyzerowanie k - tego bitu
	// if(i < k){
	// 	p = (p << (k - i));
	// 	x = x | p;
	// }
	// else{
	// 	p = (p >> (i - k));
	// 	x = x | p;
	// }
	// return x;

	//wersja bez uzycia ifow
	int bit_i = x & (1 << i); //na i-tym miejscu
	int bit_k = x & (1 << k); //na k-tym miejscy
	//sprawdzamy czy cos zmieniamy
	int pi = (bit_i >> i);//teraz oba 1 / 0
	int pk = (bit_k >> k);
	int czy_zmiana = pi ^ pk; // 1 - zmienil, 0 - nie
	//przesuwamy na k-ta pozycje czy-zmiane
	czy_zmiana <<= k;
	//zmieniamy jesli trzeba
	x = x ^ czy_zmiana;
	return x;
}

int zadanie2(){
	//nie wydaje mi się zeby to sie dalo zrobic w takim czasie
	int x = ((x & 0x55555555) + ((x >> 1) & 0x55555555)); //sumujemy pary, teraz mamy wzwzwzwz, w - wolne, z - jest tam jakas informacja
	x = ((x & 0x333333333) + ((x >> 2) & 0x33333333));
}

//zadanie 3

typedef struct A
{
	__int8_t a;
	void *b;
	__int8_t c;
	__int16_t d;
}A;//zajmowalaby mniej gdyby 

typedef struct B
{
	__uint16_t a;
	double *b; 
	void *c; 
}B;

//rozmiary: A = 6, B = 5

//zadanie 4.
/*volatile - zmienna może być zmieniona spoza programu, jej wartość odczytywana
z pamięci, nie rejestru
static - tylko raz w programie (w sensie że nie może być innych o tej samej nazwie?),
istnieje przez cały czas działania programu, zachowuje wartosc np miedzy 
wywolaniami funkcji
global static - widoczna tylko w jednym pliku
restrict - dany wskaznik nie duplikuje sie z zadnym innym, jak zapomnimy
o tym to program sie wysypie
*/
int main()
{
	//zadanie 1.
	int x, i, k;
	scanf("%i %i %i", &x, &i, &k);
	int odp = zadanie1(x, i, k);
	printf("%i\n", odp);

	//zadanie 2.

	//zadanie 3. zrobione

	//zadanie 5, 6, 7 ipad

	//zadanie 6.
}