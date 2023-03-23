import java.io.*; //co to robi???
class Osoba
{
	private String Nazwisko;
	private int wzrost;
	Osoba (String Nazwisko, int wzrost)
	{
		this.Nazwisko = Nazwisko;
		this.wzrost = wzrost;
	}
	public void drukuj()
	{
		System.out.println("Nazwisko: " + Nazwisko);
		System.out.println(wzrost);
	}

}