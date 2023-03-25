import java.util.MissingResourceException;
public class Expression extends Exception
{
    public int evaluate(String[] variables, int[] values) throws MissingResourceException
    {
        return -265;
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

    public Expression derivate(){
        return new Expression();
    }
}
