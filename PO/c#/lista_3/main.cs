using System;
using MyList;
using Dictionary;

class Program
{
	public static void Main()
	{
		int_list_test();
		string_list_test();
		int_string_dictionary_test();
	}

	static void int_list_test()
	{
		Lista<int> lista = new Lista<int>();
		Console.WriteLine(lista.is_empty());
		// lista.assign_error_value(-1);
		lista.push_front(5);
		lista.push_front(10);
		Console.WriteLine(lista.is_empty());
		lista.push_front(15);
		Console.WriteLine(lista.pop_front());
		Console.WriteLine(lista.pop_back());
		Console.WriteLine(lista.pop_front());
		Console.WriteLine(lista.is_empty()); //true
		// Console.WriteLine(lista.pop_front());  //error
		// Console.WriteLine(lista.pop_front()); //error
		lista.push_front(5);
		lista.push_front(10);
		Console.WriteLine(lista.is_empty());
		lista.push_front(15);
		Console.WriteLine(lista.pop_front());
		Console.WriteLine(lista.pop_back());
		for(int i = 0; i < 15; i++)
		{
			lista.push_back(2*i);
		}
		Console.WriteLine(lista.pop_front());
		Console.WriteLine(lista.pop_back());
		Console.WriteLine(lista.is_empty());
		Console.WriteLine(lista.pop_front());
	}

	static void string_list_test()
	{
		Lista<string> listaS = new Lista<string>();
		// listaS.assign_error_value("error");
		listaS.push_front("a");
		listaS.push_front("drugi");
		listaS.push_front("C");
		Console.WriteLine(listaS.pop_front());
		Console.WriteLine(listaS.pop_back());
		Console.WriteLine(listaS.pop_front());
		string s = "start:";
		for(int i = 0; i < 15; i++)
		{
			s += "x";
			listaS.push_back(s);
		}
		Console.WriteLine(listaS.pop_front());
		Console.WriteLine(listaS.pop_back());
		Console.WriteLine(listaS.pop_front());
	}

	static void int_string_dictionary_test()
	{
		MyDictionary<int, string> dictionary = new MyDictionary<int, string>();
		// dictionary.set_error_value("error");

		//dodanie kilku kluczy i wartosci
		dictionary.add_new_pair(3, "kota");
		dictionary.print();
		dictionary.add_new_pair(2, "ma");
		dictionary.print();
		dictionary.add_new_pair(1, "Ala");
		dictionary.print();

		//wyswietlenie
		dictionary.print();
		for(int i = 1; i < 4; i++){
			Console.Write(dictionary.find_by_key(i));
			Console.Write(" ");
		}
		Console.WriteLine();
		
		//usuniecie elementu
		dictionary.delete_value_from_key(2);
		dictionary.print();
		//wyswietlenie
		dictionary.print();
		// Console.WriteLine();
		// for(int i = 1; i < 4; i++){ //ERROR
		// 	Console.Write(dictionary.find_by_key(i));
		// 	Console.Write(" ");
		// }
		Console.WriteLine();
	}
}