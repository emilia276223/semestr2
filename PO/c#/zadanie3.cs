/*
	Emilia Wiśniewska
	lista 02: zadanie 3
	mcs zadanie1.cs
*/

using System;

class Program
{
	public static void Main()
	{
		//kilka testow na duzych intach
		BigNum a = new BigNum(123456789);
        BigNum b = new BigNum(-987654321);
		a.print();
		b.print();

        a = b.subtract(a);
        a.print();

    	a = a.add(a);
        a.print();

		power_of_two(3);
		power_of_two(13);
		power_of_two(33);
		power_of_two(43);
		power_of_two(53);
		power_of_two(63);
		power_of_two(73);
		power_of_two(83);
		power_of_two(93);
		power_of_two(103);
		power_of_two(113);
		power_of_two(312);
		power_of_two(133);
		power_of_two(600);
		power_of_two(800);
		power_of_two(1000); //przy rozmiarze 500 sie jeszcze cale wyswietla (z duzym zapasem), ale 300 moze byc za malo

	}

	static void power_of_two(int k) //do testowania programu na duzych liczbach
	{
		BigNum a = new BigNum(1); //do sprawdzania duzych dodatnich
		// BigNum a = new BigNum(-1); //do sprawdzania duzych ujemnych
		for(int i = 0; i < k; i++){
			a = a.add(a); // mnoze a przez 2
		}
		a.print(); // teraz a = 1 * 2 ^ k
	}
}

class BigNum
{
	int SIZE = 500; //maksymalny rozmiar liczby (czyli wielkosc maksymalnie 10^100)
	public int[] tab = new int[500];
	bool if_positive;

	//jesli wartosc zostaje przekroczona wyswietlane
	//i zapamietywane jest tylko SIZE najmniejszych cyfr

	public BigNum(int value)
	{
		if_positive = true;
		int i = 0;
		int x = 1;
		if(value < 0){
			x = -1;
			value *= -1;
			if_positive = false;
		}
		while(value > 0){
			tab[i] = x * (value % 10);
			i++;
			value /= 10;
		}
		
	}

	public BigNum add(BigNum next) //0 - dobrze, -1 - błąd(liczba wychodzi poza zakres)
	{
		//liczymy zakladajac ze wynik jest dodatni,
		//jak wyjdzie cos nie tam to zrobimy na odwrot
		BigNum result = new BigNum(0);
		int temp = 0;
		for(int i = 0; i < SIZE; i++){
			result.tab[i] = tab[i] + (next.tab[i] + temp);
			temp = 0;
			while(result.tab[i] < 0){
				temp --;
				result.tab[i] += 10;
			}
			while(result.tab[i] > 9){
				temp ++; 
				result.tab[i] -= 10;
			}
		}
		if(temp >= 0){
			result.if_positive = true;
			return result;
		}
		//skoro nam wyszlo ujemne, to pewnie wynik jest
		//ujemny, wiec liczymy zakladajac ze ujemny
		temp = 0;
		for(int i = 0; i < SIZE; i++){
			result.tab[i] += temp;
			temp = 0;
			while(result.tab[i] > 0){
				temp ++;
				result.tab[i] -= 10;
			}
			while(result.tab[i] < -9){
				temp --; 
				result.tab[i] += 10;
			}
		}
		result.if_positive = false;
		return result;
	}

	public BigNum subtract(BigNum next)
	{
		BigNum result = new BigNum(0);
		if(result.if_positive){
			result.if_positive = false;
		}
		else{
			result.if_positive = true;
		}
		for(int i = 0; i < SIZE; i++){
			result.tab[i] = next.tab[i] * -1;
		}
		return add(result);
	}

	public void print()
	{
		int x = 1;
		if(!if_positive){
			Console.Write("-");
			x = -1;
		}
		int i = SIZE - 1;
		while(tab[i] == 0){
			i--;
		}
		for(int j = i; j >= 0; j--){
			Console.Write(tab[j]*x);
			// Console.Write(","); //do sprawdzenia czy przypadkiem nie trzymam czegos innego niz cyfra
		}
		Console.WriteLine();
		return;
	}
}