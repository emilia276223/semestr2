import java.util.MissingResourceException;
import java.util.Objects;
import java.util.EmptyStackException;

public class Value extends Expression {
    int val;
    String variable;

    public int evaluate(String[] variables, int[] values) throws MissingResourceException
    {
        if (Objects.equals(variable, null))
            return val;
        for (int i = 0; i < variables.length; i++) {
            if(Objects.equals(variables[i], variable)) {
                return values[i];
            }
        }
        throw new MissingResourceException("missing value", "Value", "1");
    }

    public void changeValue(int x)
    {
        val = x;
    }

    public void changeValue(String s) {
        variable = s;
    }
    public String toString() {
        if (Objects.equals(variable, null))
            return Integer.toString(val);
        return variable;
    }
    public Value(int x){
        val = x;
    }
    public Value(String var) {
        variable = var;
    }

}
