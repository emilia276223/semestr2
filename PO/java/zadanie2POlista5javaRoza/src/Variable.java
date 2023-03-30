import java.util.MissingResourceException;
import java.util.Objects;

public class Variable extends Expression
{
    String x;
    public Variable(String n)
    {
        x = n;
    }
    public int evaluate(String[] variables, int[] values) throws MissingResourceException
    {
        for(int i = 0; i < variables.length; i++)
        {
            if(Objects.equals(variables[i], x))
            {
                return values[i];
            }
        }
        throw new MissingResourceException("opis problemu", "klasa, w której jest problem", "jakiś numer czy cokolwiek");
    }
    public String toString()
    {
        return x;
    }
}
