import java.util.MissingResourceException;

public class Multiply extends Expression
{
    Expression left;
    Expression right;

    public int evaluate(String[] variables, int[] values) throws MissingResourceException
    {
        return left.evaluate(variables, values) * right.evaluate(variables, values);
    }

    public String toString() {
        return ("(" +  left.toString() + " * " + right.toString() + ")");
    }

    public Multiply(Expression l, Expression r)
    {
        left = l;
        right = r;
    }
}
