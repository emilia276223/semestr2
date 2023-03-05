/*
	Emilia Wiśniewska
	lista 01: zadanie 3 (wlasna tablica)
	gcc zadanie_2.c
*/

#include <stdlib.h>
#include <stdio.h> 

typedef struct Wartosc{
	// int val;//to mozna zamienic zaleznie jakiego typu wartosc chcemy miec w tablicy
	double val;
	// char val;
} War;

War zero;
War error;

void print_val(War x){
	if(x.val == error.val){
		printf("(error, to miejsce w tablicy nie istnieje) ");
		return;
	}
	// printf("%i ", value.val);
	printf("%f ", x.val);
	// printf("%c ", value.val);	
}

typedef struct Element{
	struct Element *previous;//wskaznik na poprzedni
	struct Element *next;//wskaznik na kolejny
	War val;//wartosc
	int ind;//indeks
} Elem;

typedef struct Tablica{
	Elem *first;
	Elem *last;
	int find;
	int lind;
} Tablica;

Tablica *nowa_tablica(){
	Tablica *tab = malloc(sizeof(Tablica));
	tab -> first = NULL;
	tab -> find = 0;
	tab -> last = NULL;
	tab -> lind = 0;
}

Elem *nowy_element(int index, War x){
	Elem *elem = malloc(sizeof(Elem));
	elem -> ind = index;
	elem -> val = x;
	elem -> next = NULL;
	elem -> previous = NULL;
	return elem;
}

void nadpisz_element(Elem *elem, int index, War x){
	if(elem -> ind == index){
		elem -> val = x;
		return;
	}
	if(index < elem -> ind){
		nadpisz_element(elem -> previous, index, x);
	}
	nadpisz_element(elem -> next, index, x);
}

void dodaj(Tablica *tab, int index, War x)//wpisanie elementu do tablicy
{
	if(tab -> first == NULL){// tablica byla pusta
		Elem *e = nowy_element(index, x);
		tab -> first = e;
		tab -> last = e;
		tab -> lind = index;
		tab -> find = index;
		return;
	}
	
	//element istnieje:
	if(index <= (tab -> lind) && index >= (tab -> find)){ 
		nadpisz_element(tab -> first, index, x);
		return;
	}
	//element nie istnieje jeszcze
	if(index < (tab -> find)){//polewej wpisuje
		while(index < (tab -> find)){//dopoki brakuje
			//stworzenie nowego elementu po lewej stronie
			(tab -> find)--;
			Elem *nowy = nowy_element(tab -> find, zero);
			((tab -> first) -> previous) = nowy;
			nowy -> next = tab -> first;
			tab -> first = nowy;
		}
		//teraz juz istnieje tam element
		nadpisz_element(tab -> first, index, x);
		return;
	}
	
	//jesli wpisuje po prawej
	while(index > (tab -> lind)){//dopoki brakuje
		//stworzenie nowego elementu po lewej stronie
		(tab -> lind)++;
		Elem *nowy = nowy_element(tab -> lind, zero);
		(tab -> last) -> next = nowy;
		nowy -> previous = tab -> last;
		tab -> last = nowy;
	}
	//teraz juz istnieje tam element
	nadpisz_element(tab -> last, index, x);
	return;
}

War indeks(Tablica *tab, int index){
	if((tab -> find) > index || (tab -> lind) < index) return error;
	Elem *elem = tab -> first;
	while(elem -> ind < index){
		elem = elem -> next;
	}
	return elem -> val;
}

void show(Tablica *tab){
	printf("elementy od poczatku = %i do konca = %i:\n", tab -> find, tab -> lind);
	if(tab -> first == NULL) return;
	Elem *e;
	e = tab -> first;
	// int x = 0;
	while(e -> next != NULL){
		print_val(e -> val);
		// printf("(%i)", e -> ind);
		// if(x == 100) return;
		// x++;
		e = (e -> next);
	}
	print_val(e -> val);
	printf("\n");
	return;
}

int main()
{
	//ustawienie wartosci zero i error (zero jest wartoscia jaka przyjmuja wszystkie nienadpisane pola, error to wartosc zwracana gdy pole nie istnieje)
	// zero -> val = 0;
	zero.val = 0.0;
	error.val = -999999.9;
	// zero -> val = ' ';
	Tablica *tab;
	tab = nowa_tablica();
	War nowy;
	nowy.val = 6.0;
	dodaj(tab, 2, nowy);
	show(tab);
	// printf("\n");
	nowy.val = 5.0;
	dodaj(tab, -3, nowy);
	show(tab);
	// printf("\n");
	print_val(indeks(tab, -1));
	printf("\n");
	print_val(indeks(tab, -4));
	printf("\n");
	print_val(indeks(tab, -15));
	printf("\n");
	print_val(indeks(tab, -3));
	printf("\n");
	print_val(indeks(tab, 2));
	printf("\n");
}