public class ExpressionTree {
    public static void main(String[] args)
    {
        //wyrazenie: (x + 3) * (15 - 24)
        Expression val1 = new Value("x");
        Expression val2 = new Value(3);
        Expression val3 = new Value(15);
        Expression val4 = new Value(24);
        Expression o1 = new Operation(val1, "+", val2);
        Expression o2 = new Operation(val3, "-", val4);
        Expression wyr1 = new Operation(o1, "*", o2);

        System.out.println(wyr1.toString());
        String[] zmienne1 = {"x"};
        int[] wartosci1 = {3};

        System.out.println(wyr1.evaluate(zmienne1, wartosci1));
        wartosci1[0] = -3;
        System.out.println(wyr1.evaluate(zmienne1, wartosci1));

    }
}
