import java.util.MissingResourceException;

public class Program
{
    public static void main(String[] args) throws MissingResourceException
    {
        //expression: (x + 3) * (15 - 24)
        Expression wyr1 = new Multiply(new Add(new Variable("x"), new Const(3)),
                                        new Subst(new Const(15), new Const(24)));


        System.out.println(wyr1);
        String[] variables = {"x"};
        int[] values = {3};

        System.out.println(wyr1.evaluate(variables, values));
        values[0] = -3;
        System.out.println(wyr1.evaluate(variables, values));
        values[0] = 0;
        System.out.println(wyr1.evaluate(variables, values));
/*
        //function: x*x*x (czyli x^3), which derivative is 3*x^2
        Expression f1 = new Multiply(new Variable("x"), new Multiply(new Variable("x"), new Variable("x")));
        System.out.println("first function:");
        System.out.println(f1);
        System.out.println("it's derivative:");
        System.out.println(f1.derivate());
        //((1 * (x * x)) + (((1 * x) + (1 * x)) * x)) =
        //(x * x) + ((x + x) * x) =
        //(x ^ 2) + (2*x * x) =
        //(3 * x ^ 2), which is de derivative

        //function 2: x^2 + 5x + 3
        //derivative: 2x + 5
        Expression f2 = new Add(new Multiply(new Variable("x"), new Variable("x")),
                                new Add(new Multiply(new Variable("x"), new Value(5)), new Value(3)));
        System.out.println("second function:");
        System.out.println(f2);
        System.out.println("it's derivative:");
        System.out.println(f2.derivate());
        //(((1 * x) + (1 * x)) + (((1 * 5) + (0 * x)) + 0)) =
        //((x + x) + ((5 + 0) + 0) =
        //2*x + 5,  which is de derivative*/
    }
}