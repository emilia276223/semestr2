require './mass'
require './length'
require './area'
require './pressure'


obszar = Area.new()
obszar.metrkw = 1.0
obszar2 = Area.new()
obszar2.calkw = 1.0

array = [ {SI_metry_kwadratowe: "#{obszar.metrkw}", cale_kwadratowe: "#{obszar.calkw}"},
		  {SI_metry_kwadratowe: "#{obszar2.metrkw}", cale_kwadratowe: "#{obszar2.calkw}"},]

table_print array

print "\n\nObszar:\n"
print "| SI - metry kwadratowe |   spoza SI - cale kw  |\n"
print "________________________________________________\n"
print "|          #{obszar.metrkw}          |  #{obszar.calkw}   |\n"
print "| #{obszar2.metrkw} |          #{obszar2.calkw}          |\n"

cisnienie = Pressure.new()
cisnienie.bar = 1.0 #jednosta SI tylko przesunięta, ale to pomińmy
cisnienie2 = Pressure.new()
cisnienie2.phi = 1.0

print "\n\nCiśnienie:\n"
print "|       SI - bar      |     spoza SI - phi    |\n"
print "_______________________________________________\n"
print "|         #{cisnienie.bar}         |  #{cisnienie.phi}   |\n"
print "| #{cisnienie2.bar} |          #{cisnienie2.phi}          |\n"
