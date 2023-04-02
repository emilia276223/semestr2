import java.io.*;

public class Lista<T> implements Serializable {
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
		if(size == 0){//if element does not exist
//			throw new ArgumentException("element does not exist!!!");
		}
		if(size == 1){//if there was only one element
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
		if(size == 0){//if element does not exist
//			throw new ArgumentException("element does not exist!!!");
		}
		if(size == 1){//if there was only one element
			size = 0;
			return back.val;
		}
		Elem<T> old = back;
		back = back.next;
		size--;
		return old.val;
	}

	public boolean is_empty() //czy lista jest pusta (czyli czy size == 0)
	{
		if(size == 0){
			return true;
		}
		return false;
	}

	public static void main(String[] args) throws IOException, ClassNotFoundException {
		var lista = new Lista<String>();
		lista.push_back("Ala");
		lista.push_back("ma");
		lista.push_back("kota");
		//to try to write object in a file
//		try{
			var file = new FileOutputStream("przyklad1.txt");
			var output = new ObjectOutputStream(file);
			output.writeObject(lista);
			output.close();
			file.close();
//		}
//		catch (FileNotFoundException e){
//			System.out.println("File was not found, try with another file");
//			return;
//		} catch (IOException e) {
//			System.out.println("IOException was caught");
//			return;
//		}

		//to try to read object from a file

		Lista<String> newList;
//		try{
			var file2 = new FileInputStream("przyklad1.txt");
			var input = new ObjectInputStream(file2);
			newList = (Lista<String>) input.readObject();
			input.close();
			file.close();

			//to test if this worked:
			System.out.println(newList.pop_front());
			System.out.println(newList.pop_back());
			System.out.println(newList.pop_front());
//		}
//		catch (FileNotFoundException e){
//			System.out.println("File was not found, try with another file");
//			return;
//		} catch (IOException e) {
//			System.out.println("IOException was caught");
//			return;
//		} catch (ClassNotFoundException e) {
//			System.out.println("Class not found exception");
//			return;
//		}


	}
}
