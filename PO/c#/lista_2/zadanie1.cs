/*
	Emilia Wiśniewska
	lista 02: zadanie 1
	mcs zadanie1.cs
*/

using System; //potrzebne do wypisywania

class Program
{
	public static void Main()
	{
		IntStreamTest(10);
		PrimeStreamTest(10);
		RandomStreamTest(10);
		RandomWordStreamTest(30);
	}

	static void IntStreamTest(int k)
	{
		//wypisanie pierwszych k liczb naturalnych
		IntStream stream = new IntStream();
		for (int i = 0; i < k; i++)
		{
			Console.WriteLine(stream.next());
		}
		return;
	}

	static void PrimeStreamTest(int k)
	{
		//wypisanie pierwszych k liczb pierwszych
		PrimeStream pstream = new PrimeStream();
		for (int i = 0; i < k; i++)
		{
			Console.WriteLine(pstream.next());
		}
		return;
	}

	static void RandomStreamTest(int k)
	{
		//wypisanie k losowych liczb
		RandomStream rstr = new RandomStream();
		for (int i = 0; i < k; i++)
		{
			Console.WriteLine(rstr.next());
		}
		return;
	}

	static void RandomWordStreamTest(int k)
	{
		//wypisanie k randomowych slow o dlugosci liczb pierwszych
		RandomWordStream rwstream = new RandomWordStream();
		for (int i = 0; i < k; i++)
		{
			Console.WriteLine(rwstream.next());
		}
		return;
	}

}

class IntStream
{
	int last = 0; //jaka byla poprzednia podana
	public bool ifEos = false; //czy jeszcze zmiescimy sie w incie

	virtual public int next()
	{
		if(ifEos) return -1; //jesli przekroczylismy limit to -1 jako blad
		this.last = this.last + 1; 
		if(this.last + 1 < this.last) ifEos = true; //jesli kolejnej nie ma to eos na true
		return this.last; //zwracamy liczbe
	}

	public bool eos() //jesli juz nie ma wiecej to true
	{
		return ifEos;
	}

	virtual public void reset() //zaczynamy znowu od 0
	{
		this.last = 0;
	}

}

class PrimeStream : IntStream
{
	int last = 0; //to i tak nadpiszemy
	int nextOne = 2; //na stat pierwsza liczba pierwsza to 2
	override public int next() //nadpisujemy next z intStream
	{
		if(base.ifEos) return -1; //jesli eos to -1 jako blad
		this.last = this.nextOne;
		this.nextOne ++;
		//sprawdzenie czy bedzie mozliwa do policzenia nastepna liczba pierwsza (+ policzenie jej)
		while(!base.ifEos && !ifPrime(this.nextOne)){
			if(this.nextOne + 1 < this.nextOne) base.ifEos = true; //jesli kolejnej nie ma to eos = true
			this.nextOne++;
		}
		return this.last; //zwrocenie liczby pierwszej
	}

	bool ifPrime(int p) //sprawdzenie czy dana liczba jest pierwsza
	{
		if(p < 2) return false;
		for (int i = 2; i * i <= p; i++){
			if(p % i == 0) return false;
		}
		return true;
	}

	override public void reset() //ustawiamy last = 0 i pierwsza liczbe pierwsza na 2
	{
		this.last = 0;
		this.nextOne = 2;
	}
}

class RandomStream
{
	//zwracanie losowej liczbt\y
	Random rand = new Random();

	public int next()
	{
		return this.rand.Next();
	}

	public bool eos() {return false;}
}

class RandomWordStream
{
	RandomStream rands = new RandomStream();
	PrimeStream prime = new PrimeStream();

	public string next()
	{
		int d = prime.next(); //dlugosc slowa - kolejna liczba pierwsza
		char a;
		string s = "";
		for (int i = 0; i < d; i++)
		{
			a = 'a';
			a += (char)(rands.next() % 26); //% zeby nadal to byla litera
			s += a;
		}
		return s; //zwracamy powstale slowo
	}
}

