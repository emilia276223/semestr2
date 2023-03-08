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
		BigNum c = new BigNum(0);
		c.print();
		a.print();
		b.print();

		BigNum a1 = new BigNum(1000009);
        BigNum b1 = new BigNum(-98000001);
		BigNum c1 = new BigNum(10000);
		c1.print();
		a1.print();
		b1.print();
		BigNum a2 = new BigNum(1000006789);
        BigNum b2 = new BigNum(-987000001);
		BigNum c2 = new BigNum(0);
		c2.print();
		a2.print();
		b2.print();


        a = b.subtract(a);
        a.print();

    	a = a.add(a);
        a.print();

		//testy na malych i duzych potegach dwojki
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
		power_of_two(1000); //gdyby trzymac po jednej cyfrze potrzebne by bylo ponad 300 miejsc w tablicy
		power_of_two(10000); //miesci sie w tablicy 400 po 8 znakow (bo tylko +- 3 razy dluzsza)
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
	int SIZE = 400; //maksymalny rozmiar liczby (czyli wielkosc maksymalnie sizeOfCell^400)
	public int[] tab = new int[400];
	bool if_positive; //czy liczba jest dodatnia / nieujemna czy ujemna
	int sizeOfCell = 100000000; //10^8 zeby nie marnowac pamieci
	//jesli wartosc zostaje przekroczona wyswietlane i zapamietywane jest tylko 400 (SIZE) najmniejszych cyfr

	public BigNum(int value) //ustawienie wartosci
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
			tab[i] = x * (value % sizeOfCell); //w kazdym miejscu w tablicy trzymamy 0 - (10^8 - 1)
			i++;
			value /= sizeOfCell;
		}
		
	}

	public BigNum add(BigNum next) //0 - dobrze, -1 - błąd(liczba wychodzi poza zakres)
	{
		//liczymy zakladajac ze wynik jest dodatni,
		//jak wyjdzie na koncu temp ujemne to znaczy że wynik ujemny i policzymy jeszcze raz zakladajac ze ujemny
		BigNum result = new BigNum(0); //tu bedzie wynik
		int temp = 0; //przechowuje ile musimy dodac / odjac od nastepnej cyfry
		
		for(int i = 0; i < SIZE; i++){
			result.tab[i] = tab[i] + (next.tab[i] + temp);
			temp = 0;
			while(result.tab[i] < 0){
				temp --;
				result.tab[i] += sizeOfCell;
			}
			while(result.tab[i] > sizeOfCell - 1){
				temp ++; 
				result.tab[i] -= sizeOfCell;
			}
		}
		if(temp >= 0){ //jesli temp >= 0 to wynik jest dodatni wiec zwracamy go (temp > 0 jesli przekroczylismy limit)
			result.if_positive = true;
			return result;
		}
		//skoro nam wyszlo ujemne, to wynik jest ujemny:
		temp = 0;
		for(int i = 0; i < SIZE; i++){
			result.tab[i] += temp;
			temp = 0;
			while(result.tab[i] > 0){
				temp ++;
				result.tab[i] -= sizeOfCell;
			}
			while(result.tab[i] < -sizeOfCell + 1){
				temp --; 
				result.tab[i] += sizeOfCell;
			}
		}
		result.if_positive = false;
		return result;
	}

	public BigNum subtract(BigNum next)
	{
		//odejmowanie to to samo co dodanie liczby przeciwnej, wiec to robimy
		BigNum result = new BigNum(0);
		//zamiana na liczbe przeciwna
		if(result.if_positive){
			result.if_positive = false;
		}
		else{
			result.if_positive = true;
		}
		for(int i = 0; i < SIZE; i++){
			result.tab[i] = next.tab[i] * -1;
		}
		return add(result); //zwracamy sume z liczba przeciwna
	}

	public void print()
	{
		int x = 1;
		if(!if_positive){ //jesli ujemna to najpierw -
			Console.Write("-");
			x = -1;
		}
		int i = SIZE - 1;
		while(tab[i] == 0 && i > 0){ //co najmniej jedno pole chcemy wyswietlic (zeby sie 0 wyswietlalo)
			i--;
		}
		//zawsze raz wyswietlamy od pierwszej cyfry nie - zerowej
		Console.Write(tab[i]*x);
		i--;

		for(int j = i; j >= 0; j--){
			Console.Write((tab[j]*x).ToString("D8")); //wyswielenie na 8 miejscach (zeby nie "zjesc" zer ze srodka liczby)
		}
		Console.WriteLine();
		return;
	}
}