/*
	Emilia Wiśniewska

*/
using System.Collections;
using System;
using System.Collections.Generic;

class SlowaFibbonacciego : IEnumerable<string>
{
	
	private int n;
	// int current_word;

	public SlowaFibbonacciego(int n) {
		this.n = n;
	}

	public IEnumerator<string> GetEnumerator()
	{
		string current = "b";
		string next = "a";
		// yield return current;
		// if(n == 1) yield break;
		// yield return next;
		// if(n == 2) yield break;
		for(int i = 0; i < n; i++)
		{
			yield return current;
			string p = next + current;
			current = next;
			next = p;
		}
		yield break;
	}

	IEnumerator IEnumerable.GetEnumerator()
    {
       return GetEnumerator();
    }
}

class Program
{
	public static void Main()
	{
		Console.WriteLine("First six of fibbonacci words:");
		SlowaFibbonacciego sf = new SlowaFibbonacciego(6);
		foreach (string s in sf)
		{
			Console.WriteLine(s);
		}

		Console.WriteLine("\nFirst 15 of fibbonacci words:");
		SlowaFibbonacciego sflong = new SlowaFibbonacciego(15);
		foreach (string s in sflong)
		{
			Console.WriteLine(s);
		}
	}
}