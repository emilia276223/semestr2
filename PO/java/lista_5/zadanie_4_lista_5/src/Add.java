import java.util.MissingResourceException;
import java.util.Objects;

public class Add extends Expression
{
    Expression left;
    Expression right;

    public int evaluate(String[] variables, int[] values) throws MissingResourceException
    {
        return left.evaluate(variables, values) + right.evaluate(variables, values);
    }

    public String toString() {
        return ("(" +  left.toString() + " + " + right.toString() + ")");
    }

    public Add(Expression l, Expression r)
    {
        left = l;
        right = r;
    }

    public Expression derivative()
    {
        Expression ld = left.derivative();
        Expression rd = right.derivative();
        if(ld instanceof Value) if (ld.toString().equals("0")) return rd;
        if(rd instanceof Value) if (Objects.equals(rd.toString(), "0")) return ld;
        return new Add(ld, rd);
    }
}
