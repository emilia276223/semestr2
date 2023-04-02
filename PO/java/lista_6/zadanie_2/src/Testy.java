import java.util.Iterator;

public class Testy {
	public static void main(String[] args){

		System.out.println("\n lista 0:");
		Lista<Integer> lista1 = new Lista<Integer>();
		lista1.pushBack(3);
		lista1.pushBack(4);
		lista1.pushBack(7);
		for (int x : lista1) {
			System.out.println(x);
		}


		System.out.println("\n lista 1:");
		Lista<String> listaS = new Lista<String>();
		listaS.pushBack("kota");
		listaS.pushBack("ma");
		listaS.pushBack("Ala");
		for (String s : listaS) {
			System.out.println(s);
		}

		System.out.println("\n lista 2:");
		Lista<String> listaS2 = new Lista<String>();
		listaS2.pushFront("Ala");
		listaS2.pushFront("ma");
		listaS2.pushFront("psa");
		for (String s : listaS2) {
			System.out.println(s);
		}

		System.out.println("\n przecięcie listy 1 i 2:");
		listaS2.retainAll(listaS);
		for (String s : listaS2) {
			System.out.println(s);
		}

		Lista<String> listaS3 = new Lista<String>();
		listaS3.add("x");
		listaS3.add("y");
		listaS3.add("z");
		listaS3.add("t");
		listaS3.add("Ala");
		listaS3.add("Ala");

		System.out.println("\n lista 3:");
		for (String s : listaS3) {
			System.out.println(s);
		}


		System.out.println("\n suma list 2 i 3:");
		listaS2.addAll(listaS3);
		for (String s : listaS2) {
			System.out.println(s);
		}
	}
}
