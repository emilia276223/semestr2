import java.util.MissingResourceException;
public class Const extends Expression
{
    int value;
    public Const(int x)
    {
        value = x;
    }
    public int evaluate(String[] variables, int[] values) throws MissingResourceException
    {
        return value;
    }
    public String toString()
    {
        return Integer.toString(value);
    }
}
