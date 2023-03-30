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
        Expression ld = left.derivative();
        Expression rd = right.derivative();
        Expression leftAdd = new Multiply(ld, right);
        Expression rightAdd = new Multiply(rd, left);

        //to simplify expression:
        leftAdd = getSimplyfiedExpression(ld, right, leftAdd);
        rightAdd = getSimplyfiedExpression(rd, left, rightAdd);
        if(leftAdd instanceof Value) if (Objects.equals(leftAdd.toString(), "0")) return rightAdd;
        if(rightAdd instanceof Value) if (Objects.equals(rightAdd.toString(), "0")) return leftAdd;

        return new Add(leftAdd, rightAdd);
    }

    private Expression getSimplyfiedExpression(Expression ld, Expression right, Expression leftAdd) {
        if(ld instanceof Value) {
            if(Objects.equals(ld.toString(), "1")) leftAdd = right;
            if(Objects.equals(ld.toString(), "0")) leftAdd = new Value(0);
        }
        else if(right instanceof Value) {
            if(Objects.equals(right.toString(), "1")) leftAdd = ld;
            if(Objects.equals(right.toString(), "0")) leftAdd = new Value(0);
        }
        return leftAdd;
    }
}
