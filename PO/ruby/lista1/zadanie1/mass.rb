class Mass
	def kg # SI
		@masa
	end
	def funt # dla fizyków
		@masa * 2.20462262
	end
	def kg=(m)
		@masa = m
	end
	def funt=(m)
		@masa = m / 2.20462262
	end
end
