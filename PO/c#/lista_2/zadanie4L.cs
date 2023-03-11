//Leon

using System;
using System.Collections.Generic;
using System.Linq;

public class LazyIntList
{
    private List<int> elements = new List<int>();
    private int _size = 0;

    public int element(int i) {
        // if (i < 0) {
        //     throw new ArgumentException("Index i cannot be negative.");
        //     return elements[_size];
        // }

        if (i <= _size) {
            return elements[i-1];
        }

        for (int j = _size; j < i; j++) {
            elements.Add(j+ 1);
        }

        _size = i;

        return elements[i - 1];
    }

    public int size() {
        return _size;
    }
}

public class LazyPrimeList : LazyIntList
{
    private List<int> primes;

    public LazyPrimeList() : base()
    {
        primes = new List<int>();
    }

    public new int element(int i)
    {
        while (primes.Count < i)
        {
            int candidate = primes.Count > 0 ? primes.Last() + 1 : 2;
            while (!IsPrime(candidate))
            {
                candidate++;
            }
            primes.Add(candidate);
        }
        return primes[i - 1];
    }

    private bool IsPrime(int number)
    {
        if (number < 2)
        {
            return false;
        }
        for (int i = 2; i <= Math.Sqrt(number); i++)
        {
            if (number % i == 0)
            {
                return false;
            }
        }
        return true;
    }
}


class MojProgram {
	public static void Main() {
        LazyIntList lista = new LazyIntList();
		Console.WriteLine(lista.size());
        Console.WriteLine(lista.element(40)); // 40
        Console.WriteLine(lista.element(38)); // 38
        Console.WriteLine(lista.size()); // 40
        Console.WriteLine(lista.element(58)); // 58  ???????????????
        Console.WriteLine(lista.size()); // 58
        Console.WriteLine(" ");
        LazyPrimeList primeList = new LazyPrimeList();
        Console.WriteLine(primeList.element(1)); // 2
        Console.WriteLine(primeList.element(2)); // 3
        Console.WriteLine(primeList.element(3)); // 5
        Console.WriteLine(primeList.element(4)); // 7
        Console.WriteLine(primeList.element(10)); // 29   
    }
}