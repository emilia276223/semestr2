import java.util.MissingResourceException;

public class Expression extends Exception
{
    public int evaluate(String[] variables, int[] values) throws MissingResourceException
    {
        return -1;
    }
    public String toString()
    {
        return "error";
    }
}