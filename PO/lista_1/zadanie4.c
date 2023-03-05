#include <stdio.h>

void spacje(float x, int maximum){
	//maximum to ile cyfr przed przecinkiem ma najwieksza
	int x1 = x;
	if(x1 <= 0) x1 ++;
	while(x1 > 0){
		maximum -= 1;
		x1 /= 10;
	}
	for(int i = 0; i < maximum; i++) printf(" ");
}

int dlugosc(float m){
	if(m > 0 && m < 1) m++;
	int k = m;
	int w = 0;
	while(k > 0){
		w += 1;
		k /= 10;
	}
	return w;
}

void print(float x, int k, int lsp){//k - liczba miejsc po przecinku, lsp - spacje
	spacje(x, lsp);
	if(k == 0) printf("%.f ", x);
	else if(k == 1) printf(" %.1f", x);
	else if(k == 2) printf(" %.2f", x);
	else if(k == 3) printf(" %.3f", x);
	else if(k == 4) printf(" %.4f", x);
	else if(k == 5) printf(" %.5f", x);
	else if(k == 6) printf(" %.6f", x);
	else if(k == 7) printf(" %.7f", x);
	else if(k == 8) printf(" %.8f", x);
	else if(k == 9) printf(" %.9f", x);
	else printf(" %f", x);
}

int po_przecinku(float m){
	if();

}

void wyswietl(float y1, float y2, float x1, float x2, float skok)
{
	//maksymalne wartosci i najdluzsze po przecinku
	float px = 0, py = 0;
	float mx = x1, my = y1;
	int temp;
	// int lx = 0, ly = 0;
	while(mx < x2){
		mx += skok;
		temp = po_przecinku(mx);
		if(px < temp) px = temp;
		// lx += 1;
	}
	mx -= skok;
	// lx --;

	while(my < x2){
		my += skok;
		temp = po_przecinku(my);
		if(py < temp) py = temp;
		// ly += 1;
	}
	my -= skok;
	// ly --;

	//policzenie ile bedzie potrzebnych spacji przed liczba zeby się ładnie wyświetlało
	int sp = dlugosc(mx * my);
	int ksp = dlugosc(mx);//dla pierwszej kolumny
	
	// wyswietlenie
	
	//policzenie max ilosci miejsc po przecinku
	int p = 2;//na razie tak będzie

	//pierwszy rzad
	spacje(0, ksp);
	printf("      ");
	for(float i = x1; i < x2; i+= skok){
		print(i, p, sp);
	}
	printf("\n");

	//reszta
	for(float j = y1; j < y2; j+= skok){
		print(j, p, ksp);
		printf(":");
		for(float i = x1; i < x2; i+= skok){
			print(i * j, p, sp);
		}
		printf("\n");
	}
}

int main(){
    wyswietl(0.2, 1.3, 0.2, 3.14, 0.3);
}