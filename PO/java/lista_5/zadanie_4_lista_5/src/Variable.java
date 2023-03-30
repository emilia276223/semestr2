import java.util.MissingResourceException;
import java.util.Objects;

public class Variable extends Expression
{
    String variable;

    public int evaluate(String[] variables, int[] values) throws MissingResourceException
    {
        for (int i = 0; i < variables.length; i++) {
            if(Objects.equals(variables[i], variable)) {
                return values[i];
            }
        }
        throw new MissingResourceException("missing value", "Value", "1");
    }

    public void changeValue(String s) {

        variable = s;
    }

    public String toString() {
        return variable;
    }

    public Variable(String var) {
        variable = var;
    }

    @Override
    public Expression derivative() {
        return new Value(1);
    }
}
