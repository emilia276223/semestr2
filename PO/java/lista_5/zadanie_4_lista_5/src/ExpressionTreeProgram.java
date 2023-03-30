import java.util.MissingResourceException;

public class ExpressionTreeProgram
{
    public static void main(String[] args) throws MissingResourceException {


        //zadanie 2:

        //expression: (x + 3) * (15 - 24)
        Expression wyr1 = new Multiply(new Add(new Variable("x"), new Value(3)),
                                        new Substract(new Value(15), new Value(24)));


        System.out.println(wyr1);
        String[] variables = {"x"};
        int[] values = {3};

        System.out.println(wyr1.evaluate(variables, values));
        values[0] = -3;
        System.out.println(wyr1.evaluate(variables, values));
        values[0] = 0;
        System.out.println(wyr1.evaluate(variables, values));



        //zadanie 4:

        //function: x*x*x (czyli x^3), which derivative is 3*x^2
        Expression f1 = new Multiply(new Variable("x"), new Multiply(new Variable("x"), new Variable("x")));
        System.out.println("first function:");
        System.out.println(f1);
        System.out.println("it's derivative:");
        System.out.println(f1.derivative());
        /*
        (x * x) + ((x + x) * x) =
        (x ^ 2) + (2*x^x) =
        (3 * x ^ 2), which is the derivative
        */


        //function 2: x^2 + 5x + 3
        // derivative: 2x + 5
        Expression f2 = new Add(new Multiply(new Variable("x"), new Variable("x")),
                new Add(new Multiply(new Variable("x"), new Value(5)), new Value(3)));
        System.out.println("second function:");
        System.out.println(f2);
        System.out.println("it's derivative:");
        System.out.println(f2.derivative());
        /*
        ((x + x) + 5) =
        2*x + 5,  which is the derivative
        */
    }
}
