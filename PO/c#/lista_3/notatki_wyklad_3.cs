//zmienna danego typu moze przechowywac elementy nie tej klasy tylko podklasy
//(ale innych nie może)

class Figura //klasa chyab abstrakcyjna
{
	
}

class Kwadrat
{

}

class Punkt
{

}

//możemy np zrobić tablicę Figur, w której trzymamy kwadrat, punkt itp

//jak mozna przesuwac na obrazku:

//nadpisanie kolorem tła -> przesunięcie współrzędnych -> ponowne narysowanie
//(nir korzystamy z żadnych specyficznych własności)
//więc możemy używać do przesunięcia dowolnej figury, czyli możemy to tam zrobić i reszta po prostu odziedziczy

class Figura //klasa chyab abstrakcyjna
{
	public void przesun(float dx, float dy)
	{
		this.narysuj(kolorTla);
		x += dx;
		y += dy;
		this.narysuj(kolor);
	}	
}

//jesli wywołamy dla kwadratu to najpierw szukamy w klasie
//kwadrat funkcji (narysuj), a dopiero pozniej w nadklasie

//z dziedziczeniem trzeba uwazac

