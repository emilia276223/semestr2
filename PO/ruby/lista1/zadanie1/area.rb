# frozen_string_literal: true
require './length'
class Area
	def initialize
		@a = Length.new()
		@b = Length.new()
	end
	def hektar
		@a.metr * @b.metr / 10000
	end
	def calkw
		@a.cal * @b.cal
	end
	def metrkw
		@a.metr * @b.metr
	end
	def metrkw= (a)
		@a.metr = a
		@b.metr = 1
	end
	def hektar=(a)
		@a.metr = a * 10000
		@b.metr = 1
	end
	def calkw= (a)
		@a.cal = a
		@b.cal = 1
	end
end
