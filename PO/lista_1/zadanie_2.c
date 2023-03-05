/*
	Emilia Wiśniewska
	lista 01: zadanie 2 (ulamki)
	gcc zadanie_2.c
*/

#include <stdlib.h>
#include <stdio.h> 

typedef struct Ulamek {
	int licznik;
	int mianownik;//zazwyczaj dodatni, ujemny tylko jak jest cos nie tak
} Ulamek;

void skracanie(Ulamek *u){//skracanie ulamka
	int licz = u -> licznik;
	int mian = u -> mianownik;

	//jesli dzielimy przez 0 to (0, -1) jako blad
	if(mian == 0){
		u -> licznik = 0;
		u -> mianownik = -1;
	}

	int x = 1;
	//pozbycie się ujemnosci na razie bo tylko przeszkadza
	if(licz < 0){
		licz *= -1;
		x *= -1;
	}
	if(mian < 0){
		mian *= -1;
		x *= -1;
	}
	//skrocenie licznika z mianownikiem
	int i = 2;
	while(i < licz){ 
		if(licz%i == 0 && mian%i == 0){
			licz /= i;
			mian /= i;
		}
		i++;
	}
	//ustawienie nowego i zwrocenie
	if(x == -1) licz *= -1;
	u -> licznik = licz;
	u -> mianownik = mian;
}

Ulamek *nowy_ulamek(int num, int denom){//stworzenie nowego
	Ulamek *nowy = malloc(sizeof(Ulamek));
	nowy -> licznik = num;
	nowy -> mianownik = denom;
	skracanie(nowy);
	return nowy;
}

void show(Ulamek *u){//wyswietlenie ulamka w postaci a/b
	printf("%i/%i\n", u -> licznik, u -> mianownik);
}

void show_rounded(Ulamek *u){//wyswietlenie ulamka w postaci dziesietnej (przez co moze byc zaokraglony)
	float wynik = ((float)(u -> licznik) / (float)(u -> mianownik));
	printf("%f\n", wynik);
}

//funkcje add, substract, multiply, divide modufikują drugi z argumentów (zwracją ułamek w formie uproszczonej)
void add(Ulamek *u, Ulamek *v){
	int licz;
	int mian;
	licz = (u -> licznik * v -> mianownik)
		 + (v -> licznik * u -> mianownik);
	mian = (u -> mianownik * v -> mianownik);
	v -> licznik = licz;
	v -> mianownik = mian; 
	skracanie(v);
}

void substract(Ulamek *u, Ulamek *v){
	int licz;
	int mian;
	licz = (u -> licznik * v -> mianownik)
		 - (v -> licznik * u -> mianownik);
	mian = (u -> mianownik * v -> mianownik);
	v -> licznik = licz;
	v -> mianownik = mian; 
	skracanie(v);
}

void multiply(Ulamek *u, Ulamek *v){
	int licz = (u -> licznik * v -> licznik);
	int mian = (u -> mianownik * v -> mianownik);
	v -> licznik = licz;
	v -> mianownik = mian; 
	skracanie(v);
}

void divide(Ulamek *u, Ulamek *v){
	int licz = (u -> licznik * v -> mianownik);
	int mian = (u -> mianownik * v -> licznik);
	v -> licznik = licz;
	v -> mianownik = mian;
	skracanie(v);
}

//funkcje add_new, substract_new, multiply_new, divide_new tworzą nowy (w formie uproszczonej)
Ulamek *add_new(Ulamek *u, Ulamek *v){
	int licz;
	int mian;
	licz = (u -> licznik * v -> mianownik)
		 + (v -> licznik * u -> mianownik);
	mian = (u -> mianownik * v -> mianownik);
	Ulamek *odp = nowy_ulamek(licz, mian);//juz skrocony
	return odp;
}

Ulamek *substract_new(Ulamek *u, Ulamek *v){
	int licz;
	int mian;
	licz = (u -> licznik * v -> mianownik)
		 - (v -> licznik * u -> mianownik);
	mian = (u -> mianownik * v -> mianownik);
	Ulamek *odp = nowy_ulamek(licz, mian);//juz skrocony
	return odp;
}

Ulamek *multiply_new(Ulamek *u, Ulamek *v){
	int licz = (u -> licznik * v -> licznik);
	int mian = (u -> mianownik * v -> mianownik);
	Ulamek *odp = nowy_ulamek(licz, mian);//juz skrocony
	return odp;
}

Ulamek *divide_new(Ulamek *u, Ulamek *v){
	int licz = (u -> licznik * v -> mianownik);
	int mian = (u -> mianownik * v -> licznik);
	Ulamek *odp = nowy_ulamek(licz, mian);//juz skrocony
	return odp;
}

int main()
{
	//przykladowe dzialania do sprawdzenia poprawnosci programu
	Ulamek *u = nowy_ulamek(4,5);
	show(u);
	show_rounded(u);
	Ulamek *v = nowy_ulamek(15, 20);
	show(v);
	add(u, v);
	show(v);
	divide(u, v);
	show(v);
	substract(u, v);
	show(v);
	multiply(u, v);
	show(v);

	Ulamek *u1 = nowy_ulamek(1,2);
	Ulamek *u2 = nowy_ulamek(1,3);
	Ulamek *u3 = substract_new(u1, u2);
	show(u1);
	printf(" -\n");
	show(u2);
	printf(" =\n");
	show(u3);

}