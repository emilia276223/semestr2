import java.lang.reflect.Array;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import java.util.Objects;


public class Lista<E> implements Collection<E> {
	private class Elem<E> {
		public E val;
		public Elem<E> next;
		public Elem<E> previous;

		public Elem(E value)
		{
			val = value;
		}

		public void add_next(Elem<E> nowy) //dodanie przekazanego elementu jako nastepny
		{
			this.next = nowy;
			nowy.previous = this;
		}

		public void add_previous(Elem<E> nowy) //dodanie przekazanego elementu jako poprzedni
		{
			this.previous = nowy;
			nowy.next = this;
		}

		public String toString(){
			return (String) val;
		}
	}
	private Elem<E> front;
	private Elem<E> back; //back -> (next) -> front
	private int size = 0;

	private void createFirst(E elem) //utworzenie pierwszego elementu
	{
		size = 1;
		var nowy = new Elem<E>(elem);
		nowy.previous = null;
		nowy.next = null;
		front = nowy;
		back = nowy; //for now front and back is the same element
	}

	public void pushFront(E elem) //add new element to front of the list
	{
		if(size == 0){ //if the list was empty before
			createFirst(elem);
			return;
		}
		//otherwise
		var nowy = new Elem<E>(elem);
		if(size == 1){ //if front and back were equal
			//front becomes new element
			front = nowy;
			back.add_next(front);
			size ++;
			return;
		}
		//otherwise
		front.add_next(nowy);
		front = nowy;
		size ++;
	}

	public void pushBack(E elem)
	{
		if(size == 0){
			createFirst(elem);
			return;
		}
		var nowy = new Elem<E>(elem);
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

	public E popFront()
	{
		if(size == 0){//jesli nie ma elementu
			throw new IndexOutOfBoundsException("The list is empty!");
		}
		if(size == 1){//jesli byl tylko 1 element
			size = 0;
			var temp = front.val;
			front = null;
			back = null;
			return temp;
		}
		var oldVal = front.val;
		front = front.previous;
		front.next = null;
		size--;
		return oldVal;
	}

	public E popBack()
	{
		if(size == 0){//jesli nie ma elementu
			throw new IndexOutOfBoundsException("The list is empty!");
		}
		if(size == 1){//jesli byl tylko 1 element
			size = 0;
			var temp = back.val;
			front = null;
			back = null;
			return temp;
		}
		var oldVal = back.val;
		back = back.next;
		back.previous = null;
		size--;
		return oldVal;
	}

	public boolean isEmpty() //czy lista jest pusta (czyli czy size == 0)
	{
		return size == 0;
	}

	public boolean contains(Object o)
	{
		for(E x : this){
			if(x == o) return true;
		}
		return false;
	}

	@Override
	public Iterator<E> iterator()
	{
		return new Iterator<E>() {
			private Elem<E> current = back;
			@Override
			public boolean hasNext() {
				return current != null;
			}
			@Override
			public E next() {
				if(current == null) return null;
				else {
					var odp = current.val;
					current = current.next;
					return odp;
				}
			}
			@Override
			public void remove() {
				if(current == null) return;
				if(current != front && current != back){
					current.next.previous = current.previous;
					current.previous.next = current.next;
					current = current.next;
				}
				else{
					if(current == back){
						current = current.next;
						current.previous = null;
					}
					else{
						current.previous.next = null;
						current = null;
					}
				}
			}
		};
	}

	@Override
	public Object[] toArray()
	{
		var tab = new Object[size];
		int i = 0;
		for(E e : this) {
			tab[i] = e;
			i++;
		}
		return tab;
	}

	@Override
	public <T> T[] toArray(T[] a)
	{
		T[] r = a.length >= size ? a : (T[]) Array.newInstance(a.getClass().getComponentType(), size);
		Iterator<E> it = iterator();

		for (int i = 0; i < r.length; i++) {
			if (!it.hasNext()) { // fewer elements than expected
				if (a != r) //jeśli a było za krótkie
					return Arrays.copyOf(r, i); //tworzenie kopii zawierającej pierwsze i elementów z r
				r[i] = null; // null-terminate (wypełniamy null)
				return r;
			}
			r[i] = (T) it.next();
		}
		return r;
	}
	@Override
	public boolean add(E e)
	{
		if(contains(e)) return true;
		pushBack(e);
		return false;
	}
	@Override
	public boolean remove(Object o)
	{
		if(size == 0) return false;
		var iter = back;
		while(iter != front) {
			if(iter.val == o){
				if(iter == back){
					back = back.next;
					back.previous = null;
				}
				else{
					iter.next.previous = iter.previous;
					iter.previous.next = iter.next;
				}
				return true;
			}
			iter = iter.next;
		}
		if(Objects.equals(front.val, o)){
			front = front.previous;
			front.next = null;
			return true;
		}
		return false;
	}

	@Override
	public boolean containsAll(Collection<?> c)
	{
		for(var iter = c.iterator(); iter.hasNext(); ){
			if(!contains(iter.next())) return false;
		}
		return true;
	}

	@Override
	public boolean addAll(Collection<? extends E> c)
	{
		boolean ifOk = true;
		for(var iter = c.iterator(); iter.hasNext(); ){
			var ob = iter.next();
			if(!contains(ob)){
				add(ob);
				ifOk = false;
			}
		}
		return ifOk;
	}

	@Override
	public boolean removeAll(Collection<?> c)
	{
		boolean ifOk = true;
		for(var iter = c.iterator(); iter.hasNext(); ){
			var ob = iter.next();
			if(!remove(ob)) ifOk = false;
		}
		return ifOk;
	}

	@Override
	public boolean retainAll(Collection<?> c)
	{
		boolean ifChanged = false;
		for(E ob : this){
			if(!c.contains(ob)) {
//				System.out.println(ob + " was not found in collection");
				remove(ob);
				ifChanged = true;
			}
//			else System.out.println(ob + " was found");
		}
		return ifChanged;
	}

	@Override
	public void clear()
	{
		size = 0;
		front = null;
		back = null;
	}

	public String toString(){
		if(size() == 0) return "";
		String a = "(";
		for (E s : this) {
			a += (s.toString() + ", ");
		}
		return a.substring(0, a.length() - 2) + ")";
	}

	public int size(){
		return size;
	}

	public static void main(String[] args){

		System.out.println("\n Lista 0:");
		Lista<Integer> lista1 = new Lista<Integer>();
		lista1.pushBack(3);
		lista1.pushBack(4);
		lista1.pushBack(7);
		for (int x : lista1) {
			System.out.println(x);
		}


		System.out.println("\n Lista 1:");
		Lista<String> listaS = new Lista<String>();
		listaS.pushBack("kota");
		listaS.pushBack("ma");
		listaS.pushBack("Ala");
		System.out.println(listaS);

		System.out.println("\n Lista 2:");
		Lista<String> listaS2 = new Lista<String>();
		listaS2.pushFront("Ala");
		listaS2.pushFront("ma");
		listaS2.pushFront("psa");
		System.out.println(listaS2);

		System.out.println("\n przecięcie Listy 1 i 2:");
		listaS2.retainAll(listaS);
		System.out.println(listaS2);

		Lista<String> listaS3 = new Lista<String>();
		listaS3.add("x");
		listaS3.add("y");
		listaS3.add("z");
		listaS3.add("t");
		listaS3.add("Ala");
		listaS3.add("Ala");

		System.out.println("\n Lista 3:");
		System.out.println(listaS3);


		System.out.println("\n Suma list 2 i 3:");
		listaS2.addAll(listaS3);
		System.out.println(listaS2);
	}

}
