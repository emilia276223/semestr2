/*
	Emilia Wiśniewska
	lista 03: zadanie 2
	mcs zadanie_2.cs
*/

using System;

class Pair<K,V>
{
	public Pair<K,V> previous;
	public Pair<K,V> next;
	K key;
	V value;

	public Pair(K new_key, V val)
	{
		this.key = new_key;
		this.value = val;
		return;
	}

	public bool if_equal_to(K new_key)
	{
		if(key.Equals(new_key)){
			return true;
		}
		return false;
	}

	public void remove_key()
	{
		this.next.previous = this.previous;
		this.previous.next = this.next;
		return;
	}

	public bool if_key_exist_in_first_n(K new_key, int n)
	{
		if(n == 1)
		{
			return if_equal_to(new_key);
		}
		if(n < 1){
			return false;
		}
		if(if_equal_to(new_key)){
			return true;
		}
		return next.if_key_exist_in_first_n(new_key, (n - 1));
	}

	public V find_value(K new_key)
	{
		//zakladam ze klucz istnieje (sprawdzam to w dictionary)
		if(if_equal_to(new_key)){
			return value;
		}
		return next.find_value(new_key);
	}

	public void remove_key(K new_key)
	{
		//zakladam ze klucz istnieje (sprawdzam to w dictionary)
		if(if_equal_to(new_key)){
			this.previous.next = this.next;
			this.next.previous = this.previous;
			return;
		}
		next.find_value(new_key);
		return;
	}

	public void print_first_n(int n)
	{
		if(n <= 0){
			return;
		}
		Console.Write("({0},", key);
		Console.Write("{0})\n", value);
		if(n == 1){
			return;
		}
		next.print_first_n(n-1);
	}

	public void change_value(K new_key, V val)
	{
		if(if_equal_to(new_key)){
			this.value = val;
			return;
		}
		next.change_value(new_key, val);
		return;
	}

}

class MyDictionary<K,V>
{
	Pair<K,V> first_key; //pierwszy utworzony
	Pair<K,V> last_key; //najnowszy
	int number_of_keys = 0; 
	V ERROR;

	public void set_error_value(V val)
	{
		ERROR = val;
	}

	public void add_new_pair(K key, V val)
	{
		//pierwsze dwa przypadki, bo trzeba ladnie polaczyc w "liste"
		if(number_of_keys == 0){
			first_key = new Pair<K,V>(key, val);
			last_key = first_key;
			number_of_keys = 1;
			return;
		}
		if(number_of_keys == 1){
			//jesli klucz jest to nadpisuje wartosc
			if(first_key.if_equal_to(key)){
				first_key.change_value(key, val);
				return;
			}
			last_key = new Pair<K,V>(key, val);
			(last_key.previous) = first_key;
			(first_key.next) = last_key;
			number_of_keys ++;
			return;
		}

		//jesli klucz jest to nadpisuje wartosc
		if(first_key.if_key_exist_in_first_n(key, number_of_keys)){
			first_key.change_value(key, val);
			return;
		}
		//jesli klucz nie istnieje to tworze nowy i dopisuje na koniec
		Pair<K,V> new_key = new Pair<K,V>(key, val);
		Pair<K,V> old_previous = (last_key.previous);
		(old_previous.next) = new_key;
		new_key.previous = old_previous;
		last_key.previous = new_key;
		new_key.next = last_key;
		number_of_keys++;
		return;
	}

	public V find_by_key(K key)
	{
		if(number_of_keys == 0){
			return ERROR;
		}
		//jesli klucz istnieje to wartosc do niego przypisana
		if(first_key.if_key_exist_in_first_n(key, number_of_keys)){
			return first_key.find_value(key);
		}
		//jak nie to ERROR (wczesniej ustawiony)
		return ERROR;
	}

	public void delete_value_from_key(K key)
	{
		if(number_of_keys == 0){
			return;
		}
		if(first_key.if_key_exist_in_first_n(key, number_of_keys)){
			first_key.remove_key(key);
			number_of_keys--;
		}
		return;
	}

	public void print()
	{
		Console.WriteLine("slownik:");
		if(number_of_keys == 0) {return;}
		first_key.print_first_n(number_of_keys);
		Console.WriteLine("KONIEC\n");
		return;
	}
}

class Program
{
	public static void Main()
	{
		MyDictionary<int, string> dictionary = new MyDictionary<int, string>();
		dictionary.set_error_value("error");

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
		Console.WriteLine();
		for(int i = 1; i < 4; i++){
			Console.Write(dictionary.find_by_key(i));
			Console.Write(" ");
		}
		Console.WriteLine();

		//a gdy error == "":
		dictionary.set_error_value("");
		dictionary.print();
		Console.WriteLine();
		for(int i = 1; i < 4; i++){
			Console.Write(dictionary.find_by_key(i));
			Console.Write(" ");
		}
		Console.WriteLine();
	}
}
