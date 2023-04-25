
//zadanie 1.
//				rdi		rsi
long rsp;

/// @brief 
/// @param n 
/// @param p 
/// @return 
long pointless(long n, long *p){
	//r14 na stos
	//rbx na stos
	//rax na stos
	long rbx = n;
	if(n != 0) {
		rbx += pointless(2*n, rsp);
	}
	*p = rbx;
	rsp += 8;
	//rbx ze stosu
	//r14 ze stosu
}

//zadanie 2.



struct T
{
	long a;
	long b;
	long c;
};

struct T rdi; //niejawny wskaźnik bo to tak dziala (bo zwracamy coś duzoego)
//					rsi		rdx


struct T puzzle2(long *a, long n){
	long suma = 0;
	long max = __LONG_MAX__; //tak naprawde min
	long min = __LONG_MAX__ + 1; //tak naprawde max
	int i = 0;
	long rcx;
	while(rdx > 0){
		rcx = a[i];
		if(rcx < max) max = rcx;
		if(rcx > min) min = rcx; 
		suma += rcx;
		i++;
	}
	rdi[0] = max; //minimum //rdi.a
	suma /= rdx; //srednia //rdi.b
	a[1] = min; //maksimum //rdi.c
	a[2] = suma; 
	return rdi;//zwracamy wskaźnik na strukture
	//liczymy minimum, max i sume elementow tablicy (O dlugiści zapisanej w rdx)
}
//gdyby sygnatura nie była znana to bym dala (long *a, long *b);



//dlaczego tak?
/*
If a C++ object is non-trivial for the purpose of calls, as specified in the
C++ ABI 13, it is passed by invisible reference (the object is replaced in the
parameter list by a pointer that has class INTEGER)
*/