require './mass'
require './length'
require './area'
require './zadanie1'


obszar = Area.new()
obszar.metrkw = 1.0
obszar2 = Area.new()
obszar2.calkw = 1.0


print "\n\nObszar:\n"
print "| SI - metry kwadratowe |        cale kw        |\n"
print "________________________________________________\n"
print "|          #{obszar.metrkw}          |  #{obszar.calkw}   |\n"
print "| #{obszar2.metrkw} |          #{obszar2.calkw}          |\n"

cisnienie = Zadanie1.new()
cisnienie.bar = 1.0 #jednosta SI tylko przesunięta, ale to pomińmy
cisnienie2 = Zadanie1.new()
cisnienie2.phi = 1.0

print "\n\nCiśnienie:\n"
print "|       SI - bar      |           phi         |\n"
print "_______________________________________________\n"
print "|         #{cisnienie.bar}         |  #{cisnienie.phi}   |\n"
print "| #{cisnienie2.bar} |          #{cisnienie2.phi}          |\n"
