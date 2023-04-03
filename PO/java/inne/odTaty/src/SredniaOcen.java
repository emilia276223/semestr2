//package pikoTest.streamExamples;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.AbstractMap;
import java.util.Arrays;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class SredniaOcen {
	public static void sredniaZPliku(String fileName) throws IOException {
		Stream<String> stream = Files.lines(Paths.get(fileName));
		stream.
				map(a -> a.split(" ")).
				map(l-> new AbstractMap.SimpleEntry(l[0],
						Arrays.stream(//tu zrobie streama z tego (z pary czyli dostaje stream zawierający dwa elementy)
								//tu robię <sumaOcen, IloscOcen>
								Arrays.stream(Arrays.copyOfRange(l, 1, l.length)).
										map(s -> new double[]{Double.parseDouble(s), 1}).
										reduce((a, b) -> new double[]{a[0] + b[0], a[1] + b[1]}).
										get()
						).reduce((a,b)->a/b)//tak reduca się nie używa bo wykorzystuję to wiedząc, że mam dokładnie dwa konkretne eleenty
						//i używam, że są one w dobrej kolejności, czasem mogłoby się poopsuć i np dać mi na odwrót i byłoby źle
						//generalnie reduca używamy gdy chcemy zrobić operację łączną i przemienną bo inaczej nie mamy pewności co się zadzieje
				)).
				forEach(System.out::println); //wyrzuca tam ten jeden jedyny wynik
	}
	//jak można budować streamy?
	IntStream.range(10, 15); //sprawdzić czy Intigerów czy intów
	//ma w sobie liczby od 10 do 14 (chyba, trzeba sprawdzić)

	//ładnie się zrównolegla w Javie z użyciem streamów
	IntStream.range(10, 15).parallel().forEach(....); //domyślnie używa jeden wątek mniej niż jest w procesorze


	new Thread(()->{
		for (int i=0;i<100;i++){
			System.out.println("watek "+i);
		}
	}).start();
        for (int i=0;i<100;i++){
		System.out.println("glowny "+i);
	}
}

	//jak można budować streamy?
	//IntStream.range(10, 15); //sprawdzić czy Intigerów czy intów
	//ma w sobie liczby od 10 do 14 (chyba, trzeba sprawdzić)

	//ładnie się zrównolegla w Javie z użyciem streamów
    //IntStream.range(10, 15).parallel().forEach(....); //domyślnie używa jeden wątek mniej niż jest w procesorze