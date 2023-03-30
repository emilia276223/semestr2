import java.util.MissingResourceException;
import java.util.Objects;

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
    public Expression derivative()
    {
        var ld = left.derivative();
        var rd = right.derivative();

        //to simplify expression:
        var leftAdd = getSimplyfiedExpression(ld, right);
        var rightAdd = getSimplyfiedExpression(rd, left);
        if(leftAdd instanceof Value) if (Objects.equals(leftAdd.toString(), "0")) return rightAdd;
        if(rightAdd instanceof Value) if (Objects.equals(rightAdd.toString(), "0")) return leftAdd;

        return new Add(leftAdd, rightAdd);
    }

    private Expression getSimplyfiedExpression(Expression leftExpression, Expression rightExpression) {
        Expression result = new Multiply(leftExpression, rightExpression);
        if(leftExpression instanceof Value) {
            if(Objects.equals(leftExpression.toString(), "1")) result = rightExpression;
            if(Objects.equals(leftExpression.toString(), "0")) result = new Value(0);
        }
        else if(rightExpression instanceof Value) {
            if(Objects.equals(rightExpression.toString(), "1")) result = leftExpression;
            if(Objects.equals(rightExpression.toString(), "0")) result = new Value(0);
        }
        return result;
    }
}
