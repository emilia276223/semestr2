#include <stdio.h>
/*
int zadanie1(){
	//wersja pierwsza
	asm{
		add %rsi, %rdi
		mov %rdi, %rax
        jd end
		ret
end:    mov $ULONG_MAX, %rdi    
		ret
	}

	//wersja optymalna
	asm{
		add %rsi, %rdi
		sbb %rax, %rax ;// z tego powstanie 0 lub -1
		or  %rdi, %rax //or z samymi 1-kami (jesli wyszlo -1) lub 0 (jesli 0 i wtedy zostaje taki sam wynik)
	}
}

int zadanie2(){
	asm{
		sub %rsi, %rdi // x - y
		sbb %rax, %rax //teraz raz = 0 lub -1
		sub %rdi, %rsi //y - x z negacją możnaby ale wtedy adc rax rax
		adc $0, %rax
	}
}

int zadanie3(long x, int n){
	if(n == 0) return 0;
	int y = 0;
	for(int i = 0; i < n; i++){
		y += x & 1;
		x >> 1;
	}
}

int zadanie4(){
A -> B
B -> C
C -> F
C -> D
D -> E
D -> C
E -> B
F KONIEC

	asm{
1 puzzle2:

A:
2 		movq %rdi, %rax //rax = *s

B:
3 	.L3: movb (%rax), %r9b // pierwsza literka slowa s do r9b
4 		leaq 1(%rax), %r8 // od drugiej literki do r8 (tylko 8 literek chyba)
5 		movq %rsi, %rdx // przeniesienie *d do rdx

C:
6 	.L2: movb (%rdx), %cl //pierwsza literka z *d do cl
7 		incq %rdx //rdx++
8 		testb %cl, %cl //sprawdzamy czy cl == 0
9 		je .L4 //jesli cl == 0 to idziemy do L4 => konczymy (rax -= rdi) czyli odejmujemy wskaźnik na *d.
		//jeśli pierwsza literka == 0 to koniec (jest koniec slowa *d koniec slowa)

D:
10 		cmpb %cl, %r9b 
11 		jne .L2 //jesli cl != r9b to skaczemy
		//jesli pierwsze litery te same to skaczemy

E:
12 		movq %r8, %rax //w raxie laduje wskaznik na kolejna literke
13 		jmp .L3 //zawsze wykonuje skok

F:
14 .L4: subq %rdi, %rax //podciąg ilu pierwszych liter s się zmieścił w d
15 		ret
	}
}
*/
int zadanie4_kod(char *s char *d){
	int i = 0;
	char tempS;
	char tempD;
	int id = 0;
	while(true){
		tempS = s[i];
		i++;
		while(tempD != tempS){
			tempD = d[id];
			id++;
			if(tempD == 0) return i;
		}
	}
}
/*
int zadanie5(){
		movl %edi, %edi //wyczyszczenie starszych bitów edi
3 		salq $32, %rsi //edi -> rsi (starsza czesc)
4 		movl $32, %edx //edx = 32
5 		movl $0x80000000, %ecx //ecx = 0x80000000 
6 		xorl %eax, %eax //wyzerowanie eax


7 .L3: 	addq %rdi, %rdi 
8 		movq %rdi, %r8 
9 		subq %rsi, %r8 
10		js .L2 //jesli rsi > 2* rdi


11 		orl %ecx, %eax //eax = 11111000000000;
12 		movq %r8, %rdi //rdi = (2*rdi - rsi) 


13 .L2: shrl %ecx //ecx /= 2 => przejdziemy po wszystkich bitach
14 		decl %edx //edx --
15 		jne .L3 
16 		ret
}
*/
int zadanie5_c(__int64_t x, __int64_t y){ //dzielenie (podłoga)
	__int64_t eax = 0;
	__int64_t ecx = 0x80000000; //2^32
	y =(y << 32);
	for(int i = 0; i < 32; i++){
		x *= 2;
		if(x >= y){
			eax += ecx;
			x = x - y;
		}
		ecx /= 2;
		// printf("przejscie %i, x = %li, y = %li, wynik = %li \n", i, x, y, eax);
	}
	return eax;
}




//              rdi   rsi       rdx             rcx
int zadanie6(long *a, long v, __uint64_t s, __uint64_t e){ //start, end
	__uint64_t wynik = s + ((e - s) / 2);
	if(e > s){ //jesli przedzial tablicy ujemny:
		return -1;
	}
	__uint64_t r8 = a[wynik]; //tablica 8-bitowych
	if(a[wynik] == v) return wynik; //jesli znalezione w tablicy to zwracam gdzie
	if(a[wynik] > v){ //if grater czyli jesli większe było 
		return zadanie6(a, v, s, wynik - 1);
	}
	else{
		s = wynik + 1;
		return zadanie6(a, v, wynik + 1, e);
	}
	//całość - przeszukiwanie binarne tablicy (rekurencyjne)
}



//              rdi     rsi
long zadanie7(long x, long n){
	long wynik;
	n -= 60;
	switch (n)
	{
	case 60: case 61: 
		return 8 * x;

	case 64: 
		return x << 3;
	
	case 62:
		x = (x << 4) - x;

	case 65:
		x = x * x;

	default:
		return x + 75;
	}
}

int main(){
	int x, y;
	while(1 == 1){
		scanf("%i %i", &x, &y);
		printf("\n%i\n", zadanie5_c(x,y));

	}
}