require './length'
require './time'
require './speed'
require './acceleration'

v = Speed.new
v2 = Speed.new
v.mps = 1.0
v2.wezly = 1.0
print "Prędkość:\n"
print "|          SI         |   spoza SI - węzły   |\n"
print "_____________________________________________\n"
print "|          #{v.mps}        |  #{v.wezly}  |\n"
print "| #{v2.mps}  |          #{v2.wezly}         |\n"


a1 = Acceleration.new()
a2 = Acceleration.new()
a1.mps = 1.0
a2.mmph = 1.0
print "\n\nPrzyspieszenie:\n"
print "|           SI          |   spoza SI - mm/h^2   |\n"
print "_________________________________________________\n"
print "|           #{a1.mps}         |     #{a1.mmph}     |\n"
print "| #{a2.mps} |          #{a2.mmph}          |\n"

