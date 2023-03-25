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

        System.out.println(wyr1.toString());
        String[] zmienne1 = {"x"};
        int[] wartosci1 = {3};

        System.out.println(wyr1.evaluate(zmienne1, wartosci1));
        wartosci1[0] = -3;
        System.out.println(wyr1.evaluate(zmienne1, wartosci1));
        wartosci1[0] = 0;
        System.out.println(wyr1.evaluate(zmienne1, wartosci1));

    }
}
