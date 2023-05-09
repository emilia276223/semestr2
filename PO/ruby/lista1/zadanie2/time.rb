class Time
	def hours
		@h
	end
	def seconds
		@h * 3600
	end
	def hours=(h)
		@h = h
	end
	def seconds=(s)
		@h = s / 3600
	end
end
