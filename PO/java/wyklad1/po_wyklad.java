import java.util.EmptyStackException;

//kiedys java mial programowac male urzadzenia
//chciano tez dac troche regul zmuszajacych programiste do porzadku
//1. nazwa pliku musi miec zwiazek z klasami w nim zawartymi
//2. kazda klasa powinna byc w odrebnym pliku


//zrobilismy plik z dwiema klasami, jedna public a druga nie,
// w pliku moze byc wiecej niz jedna klasa, ale tylko jedna 
//moze byc public

//gosc mowil jakiego srodowiska uzywa, ale nie wiem

//javac Student.java
//java Student
//java -cp . Student

//przy kompilacji zawsze sie tworza osobne pliki przy kompilacji 
//(nawet jak masz wiecej niz 1 klase w pliku, to tworzy sie wiecej plikow)

//idea: java dziala wszedzie -> pliki class dzialaja wszedzie (chyba)

//nie mozna dziedziczyc po wiecej niz 1 klasie

//OBJECT

class Object
{
	Object clone(){}
	//inne ale za szybko mowi
}

//typy:

//proste: int, float, boolean

//referencyjne: Integer, Float, Boolean, interfejsy, tablice

//autoboxing - automatyczna konwersja między odpowiadającymi 
//typami prosty -> referencyjny

public class Application implements Runnable //implementowanie pewnego interfejsu
{

}

//programowanie rodzajowe
public interface List<E>
{
	//cos ale na slajdzie jest
}

//klasy to tez obiekty (klasy Class)

class Class
{
	//cos tu bylo, ale nie zdazylam
}

//mozemy sie pytac obiekt o jego pola, jakiej jest klasy i jakie ma metody
//"refleksje" (od ang. reflection, wg prowadzacego to lepszym tłumaczeniem jest introspekcja)
//mozna dzieki temu zbadac wszystkie metody i je wywolac

//WYJĄTKI
/*
reakcja na błędy: 
	dzielenie przez 0
	błąd wejscia / wyjścia (odczytywanie pliku bez uprawnień, przepełnienie
	zapisywanie na pelnym dysku)
	cos innego jeszcze

jak sobie z tym radzić:
	pokazał jak to się robiło w tyrbo pascalu
	(jak wynik rozny od 0 to znaczy ze cos zle poszło)
	
	jak w obiektowych (w tym w javie) się to robi:
		wjątki to obiekty klasy Exception
		mamy cały mechanizm zgłaszania i obsługi wyjątków
			np. jesli nie mozemy zwrócić sensownego wyniku i zgłaszamy wyjątek/błąd
			try-catch
			throw

przykład:
*/
try
{
	...
	//krytyczna instrukcja
}
catch (Exception e)
{
	//co zrobic gdy zostaje zgloszony wyjatek	
}
finally
{
	//nie powiedzial co to robi
}

// powiedzial jak to na implementacji stosu wyglada


class StackOverflowException extends Exception
{
	//nie zdazylam
	//ale cos typu super(); było
}

class Stack
{
	//jakies inne rzeczy
	public void push(int elem) throws StackOverflowException 
	{
		if(true)
			throw new StackOverflowException();
		//cos wykonaj
	}
}

Stos s = new Stos();
try {
	s.push(4);
	s.push(3);
	s.push(2);
	s.push(1);
} 
catch (StackOverflowException e) {
	// TODO: handle exception
}
catch (EmptyStackException e) {
	// TODO: handle exception
	throw e; //nie radzimy sobie z bladem, wiec "przesuwamy go dalej"
}
finally
{
	//to sie zawsze wykona
	//po co:
	//gdy otworzymy plik to nawet gdy bedzie error w zapinie chcemy 
	//go zamknąć, bo samodzielnie może się nie zamknąć i będzie duży problem
	
	//generalnie na posprzątanie po sobie
}

//wyjątki zwracane są częścią metody, musi to yć w nagłówku

//w interfejsach też się pojawiają informacje o wyjątkach
//(przykład Serializable na slajdach)

//mozna wiecej niz 1 mozliwy wyjątek zgłaszać, 
//wtedy wszystkie możliwe wyjątki piszemy po przecinku

//pakiety, biblioteki i inne:

/*
package wyklad.java;//powinien być w katalogu wykład/java

public class Test{}
*/

 import wyklad.java.Test;
 wyklad.java.Test.t //jesli boimy sie konflikow
 Test.t //jesli wiemy ze nie bedzie konfliktow

 //widzialnosc poszczególnyh atrubutów, w tym klas:
 /*
	private (automatyczne w innych, w tym nie)
	protected (domyslne w javie), widzialne w podklasach i w ramach pakietu (???)
	public
  */

  //zasady programowania obiektowego:
  //ZASADA OTWARTE - ZAMKNIETE
  /*
   klasy i metody powinny być otwarte na rozbudowę
   a zamkniete na modyfikację
*/
   Figura[] obrazek;
   for(Figura f: obrazek)
   {
		f.narysuj();
   }

  /* co jak chcemy uporzadkowac elementy?*/
   Arrays.sort(obrazek);
   /*
   normlanie kompilator powie ze sie nie da (skad ma wiedziec co jest "mniejsze"?)

   musimy wziąć interface Comparable */
   public class Figura implements Comparable<Figura>
   {
	public int compareTo(Figura o)
	{

	}
   }

//    a w punkcie:
   	public int compatrTo(Figura o)
	{
		if (o instanceof ...)
		{
			... //nie zdazylam
		}
	}

	// teraz Arrays.sort(obrazek) zadziala 
/*
	ale wtedy trzeba zamieniac compareTo zawsze przy dodawaniu jakiegos nowego
	podklasy typu Okrąg

	wiec dodanie jednej klasy dodaje nam mnóstwo pracy w sąsiednich klasach

	skoro figur jest dużo to musimy zrobić tak, zeby dodawanie nowych
	nie wiazało się z pisaniem kodu od nowa

	!!czyli myślimy do przodu!!!

	jak to można zrobić:
		bedzie na to zadanie na liście zadań
		mój pomysł: w Figurze tablice klasa - int i po tym sortujemy
		wtedy nie bedziemy zmieniac niz w klasach bo porownujemy wszystko w figurze
   */

   //cos tam tlumaczyl jeszcze do try cath

//jak tez mozna zrobić
try {
	//wywolanie programu
} catch (Exception e) {
	// pobieramy informacje z wyjatku
	//zapisujemy
	//wiemy juz co sie zadzialo u klienta jak nam wysle odpowiedni plik
	//(albo czemu u nas nie dziala)
}

//wtedy mozemy sie dowiedziec jak dobrze zareagowac na błąd
//czasem np przez dwie rozne wersje javy nie dziala, albo cos innego