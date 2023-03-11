/*
	Leon Lepkowski
	lista 02: zadanie 3
	mcs zadanie3L.cs
*/

using System;
using System.Collections.Generic;

class BigNum {
    private bool isNegative; //dziala
    private List <int> digits = new List <int>(); // lista cyfr

    public void setValue(int value) {
        if (value < 0) {
            isNegative = true;
            value = -value;
        } 
		else {
            isNegative = false;
        }
		digits = new List <int>();
        while (value > 0) {
            digits.Add(value % 10);
            value /= 10;
        }
    }


    public BigNum AddNum(BigNum other) {
        BigNum result = new BigNum();
		result.setValue(0);
        int carry = 0;

        if (this.isNegative && other.isNegative) {
			//(-a) + (-b)
			//- (a + b)
            this.isNegative = false;
			other.isNegative = false;
			result = this.AddNum(other);
			result.isNegative = true;
            return result;
        } 
        else if (this.isNegative && !other.isNegative) {
			//(-a) + b
			//b - a
			this.isNegative = false;
            return other.Subtract(this);
        }
        else if (!this.isNegative && other.isNegative) {
			//a + (-b)
			//a - b
            other.isNegative = false;
            return this.Subtract(other);
        }


        for (int i = 0; i < Math.Max(digits.Count, other.digits.Count); i++) {
            int sum = carry;

            if (i < digits.Count) {
                sum += digits[i];
            }

            if (i < other.digits.Count) {
                sum += other.digits[i];
            }

            result.digits.Add(sum % 10);
            carry = sum / 10;
        }

        if (carry > 0) {
            result.digits.Add(carry);
        }

        return result;
    }

    public BigNum Subtract(BigNum other) {

        BigNum result = new BigNum();
		result.setValue(0);
        int borrow = 0;

        if (this.isNegative && other.isNegative) {
			//(-a) - (-b)
			//b - a
			this.isNegative = false;
			other.isNegative = false;
			result = other.Subtract(this);
			return result;
        } 
        else if (this.isNegative && !other.isNegative) {
			//(-a) - b
			// - (a + b)
			this.isNegative = false;
			result = this.AddNum(other);
			result.isNegative = true;
            return result;
        }
        else if (!this.isNegative && other.isNegative) {
			//a - (-b)
			//a + b
			other.isNegative = false;
            return this.AddNum(other);
        }

		int maxSize = this.size();
		if(other.size() > maxSize){
			maxSize = other.size();
		}

        for (int i = 0; i < maxSize; i++) {
			int diff = borrow;
			if (i < this.digits.Count){
				diff += digits[i]; //roznica miedzy i- tymi cyframi
			}
            // if (diff < 0) {
            //     return other.Subtract(this);
            // }

            if (i < other.digits.Count) {
                diff -= other.digits[i];
            }

            if (diff < 0) {
                diff += 10;
                borrow = -1;
            } else {
                borrow = 0;
            }

            result.digits.Add(diff);
        }

		if(borrow < 0){
			result = other.Subtract(this);
			result.isNegative = true;
			return result;
		}

        while (result.digits.Count > 1 && result.digits[result.digits.Count - 1] == 0) {
            result.digits.RemoveAt(result.digits.Count - 1);
        }

        return result;
    }

	public int size(){
		return digits.Count;
	}

    public void Print() {
        if (isNegative) {
            Console.Write("-");
        }

        for (int i = digits.Count - 1; i >= 0; i--) {
            Console.Write(digits[i]);
        }

        Console.WriteLine();
    }
}

class MojProgram {
	public static void Main() {

		BigNum a = new BigNum();
        BigNum b = new BigNum();
        a.setValue(10);
        b.setValue(1);
		a.Print();//10
		b.Print();//1

        BigNum c = a.AddNum(b);
        c.Print();//11

        a.setValue(-10);
        b.setValue(1);
        c = a.AddNum(b);
        c.Print();//-9

        a.setValue(10);
        b.setValue(-1);
        c = a.AddNum(b);
        c.Print();//9

        a.setValue(-10);
        b.setValue(-1);
        c = a.AddNum(b);
        c.Print();//-11

        a.setValue(10);
        b.setValue(1);
        c = a.Subtract(b);
        c.Print();//9

        a.setValue(-10);
        b.setValue(1);
        c = a.Subtract(b);
        c.Print();//-11

        a.setValue(10);
        b.setValue(-1);
        c = a.Subtract(b);
        c.Print();//11

        a.setValue(-10);
        b.setValue(-1);
        c = a.Subtract(b);
        c.Print();//9


		power_of_two(3);
		power_of_two(13);
		power_of_two(33);
		power_of_two(43);
		power_of_two(53);
		power_of_two(63);
		power_of_two(73);
		power_of_two(83);
		power_of_two(93);
		power_of_two(103);
		power_of_two(113);
		power_of_two(123);
		power_of_two(133);
		power_of_two(143);
		power_of_two(143000);
		
	}
	
	static void power_of_two(int k)
	{
		BigNum a = new BigNum();
		a.setValue(1);
		for(int i = 0; i < k; i++){
			a = a.AddNum(a);
		}
		a.Print();
	}
}
