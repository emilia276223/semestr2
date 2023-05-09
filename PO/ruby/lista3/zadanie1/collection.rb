# frozen_string_literal: true

class Collection # Lista
	class Elem
		def initialize(value)
			@val = value
			@next = nil
			@prev = nil
		end
		def getNext()
			return @next
		end
		def setNext(new)
			@next = new
			if new != nil
				new.setPrevious self
			end
		end
		def getPrevious()
			return @prev
		end
		def setPrevious(new)
			@prev = new
		end
		def getValue()
			return @val
		end
	end

	def initialize
		@size = 0
		@first = nil
		@last = nil
	end
	def push (val)
		new = Elem.new(val)
		if @size == 0
			@first = new
			@last = new
		else
			if @size == 1
				@last = new
				@first.setNext(@last)
			else
				@last.setNext(new)
				@last = new
			end
		end
		@size += 1
	end

	def pop()
		if @size == 0
			return nil
		elsif @size == 1
			old = @first
			@first = nil
			@last = nil
			@size -= 1
			return old.getValue
		else
			oldval = @last.getValue
			@last = @last.getPrevious
			@size -= 1
			return oldval
		end
	end

	def length
		return @size
	end

	def swap(i, j)
		if i >= @size || j >= @size || i == j
			return nil
		else
			#policzenie odpowiednich elementow
			# print "Zamieniam #{i} z #{j} \n"
			istart = i
			jstart = j
			fst = @first
			snd = @first
			while i > 0
				fst = fst.getNext
				i -= 1
			end
			while j > 0
				snd = snd.getNext
				j -= 1
			end

			# puts "Czyli zamieniam #{fst.getValue} z #{snd.getValue}"
			#zamiana
			temp = snd.getPrevious
			if temp == nil
				fst.getPrevious.setNext snd
				fst.setPrevious nil
				temp = fst.getNext
				fst.setNext snd.getNext
				snd.setNext temp
			elsif fst.getPrevious == nil
				snd.getPrevious.setNext fst
				snd.setPrevious nil
				temp = fst.getNext
				fst.setNext snd.getNext
				snd.setNext temp
			elsif istart == (jstart - 1) # sa po kolei x, fst, snd, y
				(fst.getPrevious).setNext snd
				# puts "po kolei"
				# puts "LLL#{snd.getNext}\n"
				fst.setNext snd.getNext
				snd.setNext fst
			elsif istart == (jstart + 1) # sa po kolei x, snd, fst, y
				snd.getPrevious.setNext fst
				snd.setNext fst.getNext
				fst.setNext snd
			else
				(fst.getPrevious).setNext snd
				temp.setNext fst
				temp = fst.getNext
				fst.setNext snd.getNext
				snd.setNext temp
			end


			if fst == @first
				# puts "fst == first"
				@first = snd
			elsif snd == @first
				# puts "snd == first"
				@first = fst
			end
			if fst == @last
				# puts "fst == last"
				@last = snd
			elsif snd == @last
				# puts "snd == last"
				@last = fst
			end
		end
	end

	def get(i)
		if i >= @size
			return nil
		else
			cur = @first
			while i > 0
				cur = cur.getNext
				i -= 1
			end
			return cur.getValue
		end
	end

	def display
		cur = @first
		x = 0
		print "("
		while cur != nil
			if x > 20
				print "\n"
				return
			end
			print cur.getValue
			print ", "
			cur = cur.getNext
			x += 1
		end
		print ")\n"
	end
end

class Sorter
	def sort1(kolekcja) #powolniejszy (bogo-sort), nie ma pewnosci, że sie zakończy, ale dla tablic do 4 elementow powienien
		def czyPosortowana(kolekcja)
			# kolekcja.display
			i = 0
			while i < kolekcja.length - 1
				if kolekcja.get(i) > kolekcja.get(i + 1)
					return false
				end
				i += 1
			end
			return true
		end
		l = kolekcja.length
		rand = Random.new()
		x = 0
		while !czyPosortowana(kolekcja)
			x += 1
			i = (rand.rand * (Float l)).to_i
			j = (rand.rand * (Float l)).to_i
			kolekcja.swap(i, j)
		end
		x
	end

	def sort2(kolekcja) # ten szybszy (poza skrajnymi przypadkami) - cos al'a bubble-sort
		l = kolekcja.length
		elem = l - 1
		x = 0
		while elem >= 0
			j = elem + 1
			i = elem
			while j < l && kolekcja.get(i) > kolekcja.get(j)
				kolekcja.swap(i, j)
				i += 1
				j += 1
				x += 1
			end
			elem -= 1
		end
		x
	end
end

lista1 = Collection.new
lista1.push 2
lista1.push 1
lista1.push 3
lista1.push 7
lista1.push 6
lista1.push 9

lista1.swap(2, 3)


sort = Sorter.new
puts "Sortowanie wolne:"
puts "wykonano #{sort.sort1(lista1)} operacji"

lista1.display

lista2 = Collection.new
lista2.push 4
lista2.push 2
lista2.push 6
lista2.push 8
lista2.push 4
lista2.push 2
lista2.push 6
lista2.push 9
lista2.push 4
lista2.push 2
lista2.push 15

puts "Sortowanie szybkie:"
puts "wykonano #{sort.sort2(lista2)} operacji"
lista2.display

