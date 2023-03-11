
using System;

class Elem<T>
{
	public T val;
	public Elem<T> next;
	public Elem<T> previous;

	public Elem(T value)
	{
		this.val = value;
	}

	public void add_next(Elem<T> nowy)
	{
		this.next = nowy;
		nowy.previous = this;
	}

	public void add_previous(Elem<T> nowy)
	{
		this.previous = nowy;
		nowy.next = this;
	}
}



class Lista<T>
{
	private Elem<T> front;
	private Elem<T> back;
	private int size;

	//na razie
	T ERROR;
	// string ERROR = "";
	public void assign_error_value(T val)
	{
		ERROR = val;
	}

	public Lista()
	{
		this.size = 0;
	}

	private void create_first(T elem)
	{
		size = 1;
		Elem<T> nowy = new Elem<T>(elem);
		front = nowy;
		back = nowy;
	}

	public void push_front(T elem)
	{
		if(size == 0){
			create_first(elem);
			return;
		}
		Elem<T> nowy = new Elem<T>(elem);
		if(size == 1){
			front = nowy;
			back.add_next(front);
			size ++;
			return;
		}
		front.add_next(nowy);
		front = nowy;
		size ++;
	}

	public void push_back(T elem)
	{
		if(size == 0){
			create_first(elem);
			return;
		}
		Elem<T> nowy = new Elem<T>(elem);
		if(size == 1){
			back = nowy;
			back.add_next(front);
			size ++;
			return;
		}
		back.add_previous(nowy);
		back = nowy;
		size ++;
	}

	public T pop_front()
	{
		if(size == 0){
			return ERROR;
		}
		if(size == 1){
			size = 0;
			return front.val;
		}
		Elem<T> old = front;
		front = front.previous;
		size --;
		return old.val;
	}

	// public T pop_back(T elem)
	// {
	// 	int x = 0;
	// }

	public bool is_empty()
	{
		if(size == 0){
			return true;
		}
		return false;
	} 
}

class Program
{
	public static void Main()
	{
		Lista<int> lista = new Lista<int>();
		lista.assign_error_value(-1);
		lista.push_front(5);
		lista.push_front(10);
		lista.push_front(15);
		Console.WriteLine(lista.pop_front());
		Console.WriteLine(lista.pop_front());
		Console.WriteLine(lista.pop_front());
		Console.WriteLine(lista.pop_front());
	}
}
