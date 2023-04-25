class Length
	def km
		@km
	end
	def miles
		@km / 1.852
	end
	def mm
		@km * 1000 * 1000
	end
	def metr
		@km * 1000
	end
	def km=(l)
		@km = l
	end
	def miles=(l)
		@km = l * 1.852
	end
	def mm=(x)
		@km = x/(1000 * 1000)
	end
	def metr=(x)
		@km = x / 1000
	end
end
