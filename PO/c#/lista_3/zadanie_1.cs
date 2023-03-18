/*
	Emilia Wiśniewska
	lista 03: zadanie 1

	uruchomienie programu:(jak ja to robiłam)
	1. utworzenie dll
	mcs -t:library zadanie_1.cs
	2. utworzenie pliku wykonywalnego main1
	mcs -r:zadanie_1.dll main1.cs
	3. uruchomienie
	./main1.exe

*/
using System;

namespace MyList
{
	
	class Elem<T>
	{
		public T val;
		public Elem<T> next;
		public Elem<T> previous;

		public Elem(T value)
		{
			this.val = value;
		}

		public void add_next(Elem<T> nowy) //dodanie przekazanego elementu jako nastepny
		{
			this.next = nowy;
			nowy.previous = this;
		}

		public void add_previous(Elem<T> nowy) //dodanie przekazanego elementu jako poprzedni
		{
			this.previous = nowy;
			nowy.next = this;
		}
	}

	public class Lista<T>
	{
		private Elem<T> front;
		private Elem<T> back;
		private int size;

		public Lista()//utworzenie listu, na poczatku długość 0
		{
			this.size = 0;
		}

		private void create_first(T elem) //utworzenie pierwszego elementu
		{
			size = 1;
			Elem<T> nowy = new Elem<T>(elem);
			front = nowy;
			back = nowy; //na razie poczatkiem i koncem jest ten sam element
		}

		public void push_front(T elem) //dopisanie nowego elementu do "poczatku" listy
		{
			if(size == 0){ //jesli byla pusta to tworzumu pierwszy element
				create_first(elem);
				return;
			}
			//jesli nie byla pusta
			Elem<T> nowy = new Elem<T>(elem);
			if(size == 1){ //jesli miala rozmiar jeden, czyli front == back
				//zamieniamy front na ten nowy element
				front = nowy;
				back.add_next(front);
				size ++;
				return;
			}
			//w pozostaluch przypadkach
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
			if(size == 0){//jesli nie ma elementu
				throw new ArgumentException("element does not exist!!!");
			}
			if(size == 1){//jesli byl tylko 1 element
				size = 0;
				return front.val;
			}
			Elem<T> old = front;
			front = front.previous;
			size--;
			return old.val;
		}

		public T pop_back()
		{
			if(size == 0){//jesli nie ma elementu
				throw new ArgumentException("element does not exist!!!");
			}
			if(size == 1){//jesli byl tylko 1 element
				size = 0;
				return back.val;
			}
			Elem<T> old = back;
			back = back.next;
			size--;
			return old.val;
		}

		public bool is_empty() //czy lista jest pusta (czyli czy size == 0)
		{
			if(size == 0){
				return true;
			}
			return false;
		} 
	}
}
