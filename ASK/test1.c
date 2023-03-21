#include <stdio.h>
#include <time.h>
#include <stdlib.h>

int main()
{
	srand(time(NULL));
// 	int tab[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

// 	int n = 10;
// 	for(int i = 0; i < n; i++)
// 	{
// 		printf("%i\n", i[tab]);
// 	}
	int a = 1;
	int b = 1;
	int c = 1;
	double da = a;
	double db = b;
	double dc = c;
	// while(((da * db) * dc == da * (db * dc)))
	// {
	// 	a = rand();
	// 	b = rand();
	// 	c = rand();
	// 	da = a;
	// 	db = b;
	// 	dc = c;
	// }		
	printf("%i %i %i\n", a, b, c);
			printf("%lf != %lf", (da * db) * dc, da * (db * dc));
			// return 0;

	//90129766 484274390 877454434 nie dzialaja
	//nie dziala INT_MAX, INR_MAX, INR_MAX - 128

	int x = 0;
	int z = rand();
	double dx = x;
	double dz = z;
	printf("\n\n%lf %lf", dx/dx, dz/dz);
	if(dx/dx != dz/dz)
	{
		printf("\n\nAAA");
	}

	for(int i = -1 - __INT_MAX__; i< __INT_MAX__; i++)
	{
		double dp = i;
		if((float)i != (float)dp)
		{
			printf("\n %i ", i);
		}
	}
}