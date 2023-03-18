using System;
using Dictionary;


class Program
{
	public static void Main()
	{
		int_string_dictionary_test();
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
		// dictionary.add_new_pair(2, "nie ma"); //error, ponieważ do klucza 2 już jest przypisana jakas wartosc
		// dictionary.print();
		dictionary.add_new_pair(1, "Ala");
		dictionary.print();

		//wyswietlenie
		for(int i = 1; i < 4; i++){
			Console.Write(dictionary.find_by_key(i));
			Console.Write(" ");
		}
		Console.WriteLine();
		Console.WriteLine();
		
		//usuniecie elementu
		dictionary.delete_value_from_key(2);
		dictionary.print();
		//wyswietlenie
		// for(int i = 1; i < 4; i++){ //ERROR ponieważ nie istnieje żaden element pod kluczem 2
		// 	Console.Write(dictionary.find_by_key(i));
		// 	Console.Write(" ");
		// }
	}
}
