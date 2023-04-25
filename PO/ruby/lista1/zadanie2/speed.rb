require './length'
require './time'
class Speed
	def initialize()
		@l = Length.new()
		@t = Time.new()
	end
	def kmph
		@l.km / @t.hours
	end
	def kmps
		@l.km / @t.seconds
	end
	def wezly
		@l.miles / @t.hours
	end
	def mmph
		@l.mm / @t.hours
	end
	def mps
		@l.metr / @t.seconds
	end
	def kmph=(x)
		@l.km = x
		@t.hours = 1.0
	end
	def wezly=(x)
		@l.miles = x
		@t.hours = 1.0
	end
	def kmps=(x)
		@l.km = x
		@t.seconds = 1.0
	end
	def mmph=(x)
		@l.mm = x
		@t.hours = 1.0
	end
	def mps=(x)
		@l.metr = x
		@t.seconds = 1.0
	end
end
