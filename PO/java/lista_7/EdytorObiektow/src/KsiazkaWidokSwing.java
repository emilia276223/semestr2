import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class KsiazkaWidokSwing implements ActionListener {
	Ksiazka ksiazka;
	JFrame frame;
	Container kontener;
	JTextField tytul;
	JTextField wydawnictwo;
	JTextField rok_wydania;

	public KsiazkaWidokSwing(Ksiazka k){
		ksiazka = k;
		frame = new JFrame("Edycja książki");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		//podawanie i uswanie kontrolek: (gdzie je trzymamy)
		kontener = frame.getContentPane();
		//ustawienie kontrolek itp:
		GridLayout layout = new GridLayout(4, 2);
		kontener.setLayout(layout);

		//tytuł
		JLabel tytul_etykieta = new JLabel("Tytuł");
		kontener.add(tytul_etykieta);
		tytul = new JTextField(ksiazka.tytul, 40);
		kontener.add(tytul);

		//wydawnictwo
		JLabel wydawnictwo_etykieta = new JLabel("Wydawnictwo");
		kontener.add(wydawnictwo_etykieta);
		wydawnictwo = new JTextField(ksiazka.wydawnictwo, 40);
		kontener.add(wydawnictwo);

		//rok wydania
		JLabel rok_wydania_etykieta = new JLabel("Wydawnictwo");
		kontener.add(rok_wydania_etykieta);
		rok_wydania = new JTextField(Integer.toString(ksiazka.rokWydania), 40);
		kontener.add(rok_wydania);
	}

	public void actionPerformed(ActionEvent e) {
		//JTextfield.getText();
	}

	public void Edycja(){

	}
}
