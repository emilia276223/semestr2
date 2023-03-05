#include <stdio.h>

int zadanie1(int x, int i, int k){//moze jest dobrze?
	//pierwsza wersja (z if-ami)
	if(i == k) return x;
	
	int p = (1 << i) & x;
	int p2 = ~(1 << k);
	x = (x & p2);//wyzerowanie k - tego bitu
	if(i < k){
		p = (p << (k - i));
		x = x | p;
	}
	else{
		p = (p >> (i - k));
		x = x | p;
	}
	return x;
}

int zadanie2(){
	//nie wydaje mi się zeby to sie dalo zrobic w takim czasie

}

//zadanie 3

typedef struct A//6 bajtow
{
	__int8_t a;//1 bajt
	void *b;//1 bajt
	__int8_t c; // 1 bajt + przerwa
	__int16_t d; // 2 bajty
}A;//zajmowalaby mniej gdyby 

typedef struct B//5 bajtow
{
	__uint16_t a; //2 bajty
	double *b; // 2 bajty
	void *c; // 1 bajt
}B;

//rozmiary: A = 6, B = 5

//zadanie 4.


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