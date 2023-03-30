import java.util.MissingResourceException;
public class Expression extends Exception
{
    public int evaluate(String[] variables, int[] values) throws MissingResourceException
    {
        throw new MissingResourceException("expression not declared", "Expression", "1");
    }
    public String toString()
    {
        return "error";
    }
    public static int main()
    {
        System.out.println("Hello World");
        return 0;
    }

    public Expression derivative(){
        return new Expression();
    }
}
