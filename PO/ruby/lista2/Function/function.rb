class Function
	def initialize(&blok)
		@func = blok
		@dx = 0.0001
	end

	def value(x)
		return @func.call(x)
	end

	def deriv(x)
		return (value(x + @dx) - value(x - @dx))/(2 * @dx)
	end

	def field(a, b)
		da = (Float (b - a))/1000
		k = 0
		pole = 0
		while(k < 1000)
			pole += value(a + k * da) * da
			k += 1
		end
		return pole
	end

	def zero(a, b, e)
		if e <= 0
			return nil
		end
		k = 1000
		d = nil
		u = nil
		if value(a) < e && value(a) > -e
			return a
		end
		if  value(b) < e && value(b) > -e
			return b
		end
		if value(a) > 0
			d = a
		else
			u = a
		end
		if value(b) > 0
			d = b
		else
			u = b
		end
		rand = Random.new()
		if u == nil
			# szukam ujemnego
			i = 0
			while (i < k)
				x = rand.rand
				x = (Float(b - a)) * x + (Float a)
				if value(x) <= 0
					u = x
					i = k
				end
				i += 1
			end
		end
		if d == nil
			# szukam dodatniego
			i = 0

			while (i < k)
				x = rand.rand
				x = (Float(b - a)) * x + (Float a)
				if value(x) >= 0
					d = x
					i = k
				end
				i += 1
			end
		end
		if u == nil || d == nil
			return nil
		end

		#szukamy miejsca zerowego miedzy nimi (binsearch)
		i = 0
		while (i < 100)
			s = (Float (d + u)) / 2

			if (value(s) < e) && (value(s) > -e)
				return s
			end
			if value(s) > 0
				d = s
			else
				u = s
			end
			i += 1
		end
		return nil
	end
end

class FunctionGp < Function
	def gnuplot (a, b)
		seed = 100
		file = File.new("wykres.dat", "w")
		da = (Float (b - a)) / seed
		k = 0
		while(k <= seed)
			x = a + da * k
			file.write("#{x}		#{value(x)}\n")
			k += 1
		end
		file.close
	end
end


blok = proc { |x| x * x -1}
print blok.call(3)
print "\n"

f = Function.new() { |x| x * x - 1}
print f.value(3.5)
print "\n"
print f.deriv(2)
print "\n"
print f.field(1, 3)
print "\n"

print f.zero(-3, 3, 0.1) # metoda zakładam, że funkcja jest ciągła i znajduję element ujemnuy i dodatni

fg = FunctionGp.new() { |x| x * x - 1}
fg.gnuplot(-3, 5)
