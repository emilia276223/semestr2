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

	public boolean contains(Object o) {
		var iter = front;
		while(!Objects.equals(iter, back)) {
			if(Objects.equals(iter, o)) return true;
			iter = iter.next;
		}
		return false;
	}

	@Override
	public Iterator<E> iterator() {
		Iterator<E> it = new Iterator<E>() {

			private final Elem<E> Ifront = front;
			private final Elem<E> Iback = back;
			private Elem<E> current = Ifront;



			@Override
			public boolean hasNext() { //upewnic sie czy czyszcze nexty
				return current.next != null;
			}

			@Override
			public E next() {
				if(current.next == null) return null;
				else {
					var odp = current.val;
					current = current.next;
					return odp;
				}
			}

			@Override
			public void remove() {
				if(current != Ifront && current != Iback){
					current.next.previous = current.previous;
					current.previous.next = current.next;
					current = current.next;
				}
			}
		};
		return it;
	}

	@Override
	public Object[] toArray() {
		var tab = new Object[size];
		var iter = front;
		int i = 0;
		while(!Objects.equals(iter, back)) {
			tab[i] = iter;
			iter = iter.next;
			i++;
		}
		return tab;
	}

	@Override
	public <T> T[] toArray(T[] a) {
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
	public boolean add(E e) {
		if(contains(e)) return true;
		pushBack(e);
		return false;
	}
	@Override
	public boolean remove(Object o) {
		if(size == 0) return false;
		var iter = front;
		while(iter != back) {
			if(iter == o){
				iter.next.previous = iter.previous;
				iter.previous.next = iter.next;
				return true;
			}
			iter = iter.next;
		}
		if(Objects.equals(back, o)){
			back = back.previous;
			back.next = null;
			return true;
		}
		return false;
	}

	@Override
	public boolean containsAll(Collection<?> c) {
		for(var iter = c.iterator(); iter.hasNext(); ){
			if(!contains(iter.next())) return false;
		}
		return true;
	}

	@Override
	public boolean addAll(Collection<? extends E> c) {
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
	public boolean removeAll(Collection<?> c) {
		boolean ifOk = true;
		for(var iter = c.iterator(); iter.hasNext(); ){
			var ob = iter.next();
			if(!remove(ob)) ifOk = false;
		}
		return ifOk;
	}

	@Override
	public boolean retainAll(Collection<?> c) {
		boolean ifChanged = false;
		for(var iter = iterator(); iter.hasNext(); ){
			var ob = iter.next();
			if(!c.contains(ob)) {
				remove(ob);
				ifChanged = true;
			}
		}
		return ifChanged;
	}

	@Override
	public void clear() {
		size = 0;
		front = null;
		back = null;
	}

	public int size(){
		return size;
	}

}
