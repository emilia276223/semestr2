#include <stdio.h>

__uint64_t zera(__uint64_t x);

int main(){
	__uint64_t x = 0;
	while(1 == 1){
		scanf("%li", &x);
		printf("%lu", zera(x));
	}
}