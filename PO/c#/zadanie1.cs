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
	int last = 0;
	public bool ifEos = false;

	virtual public int next()
	{
		if(ifEos) return -1;
		this.last = this.last + 1;
		if(this.last + 1 < this.last) ifEos = true;
		return this.last;
	}

	public bool eos()
	{
		return ifEos;
	}

	virtual public void reset()
	{
		this.last = 0;
	}

}

class PrimeStream : IntStream
{
	int last = 0;
	int nextOne = 2;
	override public int next()
	{
		if(base.ifEos) return -1;
		this.last = this.nextOne;
		this.nextOne ++;
		//sprawdzenie czy bedzie mozliwa do policzenia nastepna (+ policzenie jej)
		while(!base.ifEos && !ifPrime(this.nextOne)){
			if(this.nextOne + 1 < this.nextOne) base.ifEos = true;
			this.nextOne++;
		}
		return this.last;
	}

	bool ifPrime(int p)
	{
		if(p < 2) return false;
		for (int i = 2; i * i <= p; i++){
			if(p % i == 0) return false;
		}
		return true;
	}

	override public void reset()
	{
		this.last = 0;
		this.nextOne = 2;
	}
}

class RandomStream
{
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
		int d = prime.next();
		char a = 'a';
		string s = "";
		for (int i = 0; i < d; i++)
		{
			a = 'a';
			a += (char)(rands.next() % 26);
			s += a;
			// s += "x";
		}
		return s;
	}
}

