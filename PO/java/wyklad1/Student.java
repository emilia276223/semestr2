public class Student extends Osoba
{
	String kierunek;
	Student(String kierunek, String Nazwisko, String wiek) //na wykladzie jest jak to dobrze zrobic
	{
		super.Osoba(Nazwisko, wiek);//odwolanie sie do nadklasy
		this.kierunek = kierunek;
	}
	public void drukuj() //nie trzeba pisac ze nadpisujemy
	{
		super.drukuj();
	}

	public static void main(String kierunek)//za szybko mowi zeby wszystko ogarnac
	{
		//main sluzy przede wszystkim do testowania klas
	}
}