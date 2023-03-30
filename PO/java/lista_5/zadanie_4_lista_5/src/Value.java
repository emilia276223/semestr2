import java.util.MissingResourceException;
import java.util.Objects;

public class Value extends Expression
{
    int val;
    public int evaluate(String[] variables, int[] values) throws MissingResourceException
    {
        return val;
    }

    public void changeValue(int x)
    {
        val = x;
    }

    public String toString() {
        return Integer.toString(val);
    }

    public Value(int x){
        val = x;
    }

    @Override
    public Expression derivative() {
        return new Value(0);
    }
}
