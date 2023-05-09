require './area'
require './length'
require './mass'
class Zadanie1
	def initialize()# w paskalach
		@mass = Mass.new()
		@area = Area.new()
	end
	def bar
		# g = 10 N/kg
		# g * @mass.kg / (@area.metr * 10000)
		@mass.kg / (@area.metrkw * 10000)
	end
	def phi
		@mass.funt / @area.calkw
	end
	def bar=(p)
		@mass.kg = p * 10000
		@area.metrkw = 1.0
	end
	def phi=(p)
		@mass.funt = p
		@area.calkw = 1
	end
end
