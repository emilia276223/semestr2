public class ExpressionTreeProgram
{
    public static void main(String[] args)
    {
        //wyrazenie: (x + 3) * (15 - 24)
        Expression val1 = new Variable("x");
        Expression val2 = new Value(3);
        Expression val3 = new Value(15);
        Expression val4 = new Value(24);
        Expression o1 = new Add(val1, val2);
        Expression o2 = new Substract(val3, val4);
        Expression wyr1 = new Multiply(o1, o2);

        System.out.println(wyr1);
        String[] zmienne1 = {"x"};
        int[] wartosci1 = {3};

        System.out.println(wyr1.evaluate(zmienne1, wartosci1));
        wartosci1[0] = -3;
        System.out.println(wyr1.evaluate(zmienne1, wartosci1));
        wartosci1[0] = 0;
        System.out.println(wyr1.evaluate(zmienne1, wartosci1));

        //funkcja: x*x*x (czyli x^3), wynik powinien być równy 3*x^2
        Expression f1 = new Multiply(new Variable("x"), new Multiply(new Variable("x"), new Variable("x")));
        System.out.println("pierwsza funkcja:");
        System.out.println(f1);
        System.out.println("jej pochodna:");
        System.out.println(f1.derivate());
        //((1 * (x * x)) + (((1 * x) + (1 * x)) * x)) =
        //(x * x) + ((x + x) * x) =
        //(x ^ 2) + (2*x * x) =
        //(3 * x ^ 2), co jest poprawną pochodną

        //funcja 2: x^2 + 5x + 3
        //pochodna: 2x + 5
        Expression f2 = new Add(new Multiply(new Variable("x"), new Variable("x")),
                                new Add(new Multiply(new Variable("x"), new Value(5)), new Value(3)));
        System.out.println("druga funkcja:");
        System.out.println(f2);
        System.out.println("jej pochodna:");
        System.out.println(f2.derivate());
        //(((1 * x) + (1 * x)) + (((1 * 5) + (0 * x)) + 0)) =
        //((x + x) + ((5 + 0) + 0) =
        //2*x + 5, co jest poprawnym wynikiem
    }
}
