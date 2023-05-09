require './length2'
require './time'
require './speed'
class Acceleration
	def initialize()
		@v = Speed.new()
		@t = Time.new()
	end
	def kmps
		@v.kmps / @t.seconds
	end
	def mmph
		@v.mmph / @t.hours
	end
	def mps
		@v.mps / @t.seconds
	end
	def kmps=(x)
		@v.kmps = x
		@t.seconds = 1.0
	end
	def mmph=(x)
		@v.mmph = x
		@t.hours = 1.0
	end
	def mps=(x)
		@v.mps = x
		@t.seconds = 1.0
	end
end
