import java.util.MissingResourceException;
import java.util.Objects;
import java.util.EmptyStackException;

public class Operation extends Expression
{
    String operator; //*, + or -, we dont do dividing because we don't want more problems
    Expression left;
    Expression right;

    public int evaluate(String[] variables, int[] values) throws MissingResourceException {
        int leftval = left.evaluate(variables, values);
        int rightval = right.evaluate(variables, values);
        //if one of the previous throws an exception we would rethrow it anyway, so why bother

        if (Objects.equals(operator, "+"))
            return leftval + rightval;
        else if (Objects.equals(operator, "-"))
            return leftval - rightval;
        else if (Objects.equals(operator, "*"))
            return leftval * rightval;
        //if operator different from the possible ones we throw an error
        else throw new MissingResourceException("missing operator", "Operation", "1");
    }

    public String toString() {
        return ("(" +  left.toString() + " " + operator + " " + right.toString() + ")");
    }

    public void changeValue(String s) {
        operator = s;
    }

    public Operation(Expression l, String oper, Expression r)
    {
        right = r;
        left = l;
        operator = oper;
    }
}
