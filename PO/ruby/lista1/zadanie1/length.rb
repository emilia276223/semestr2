class Length
	def metr # SI
		@metr
	end
	def jard
		@metr * 1.0936133
	end
	def cal
		@metr * 39.3700787
	end
	def metr=(d)
		@metr = d
	end
	def jard=(d)
		@metr = d / 1.0936133
	end
	def cal=(d)
		@metr = d / 39.3700787
	end
end
