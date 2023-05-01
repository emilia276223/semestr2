/*
		# podzielenie wektorow z rdi na dwa zestawy (ABCDEFGH) -> (A0C0E0G0), (0B0D0F0H); (rdi ma A)
        mov %rdi, %r9
		and .LC1, %rdi
		xor %rdi, %r9

		# tak samo podzielenie wektorów z rsi (rsi ma A)
        mov %rsi, %r8
		and .LC1, %rsi
		xor %rsi, %r8

		# dodawanie z nasyceniem B...
		lea (%r8, %r9), %rcx

		# teraz jesli suma jest powyzej 127 to jest 1 na 1 miejscu liczby (a wczesniej w zadnej z liczb nie bylo)
		# a jak ponizej -128 to na miejscu jeden przed 
		xor %r8, %r9 # zeby sprawdzic czy byly ujemne (co najmniej jedna z nich)
		and .LC2, %r9 # to, co bylo ujemne w jednej z nich (same "wartości ujemności")
		mov %r9, %r10 # w r10 info, jesli bylo cos ujemnnego

		# jesli w co najmniej jednej z nich bylo ujemne to nie chcemy tego brac pod uwage 
		mov %rcx, %r8
		and .LC4, %r8 # mamy tylko bity, ktore cos mowia o overflowie lub nie
		xor %r8, %r9 # jesli "ujemny" dlatego ze tam jeden byl ujemny to nas nie interesuje

		 
		* teraz mamy w %r9 bity zapalone, jesli wystapil jakis overflow
		* chcemy, zeby zaleznie od zapalonych bitow powstaly nam takie liczby: 
		* 110000000 -> 10000000 = 01111111 + 1
		* 100000000 -> 10000000 = 01111111 + 1
		* 010000000 -> 01111111
		* 000000000 -> liczba bez zmian
		* robimy to sziftem i mnozeniem
 		

		mov %r9, %rax
		shr $1, %r9
		xor %r9, %rax # teraz 1(1 lub 0)000000 lub 00000000 (jesli bylo ok)
		and %rax, %r10 # teraz zaznaczone gdy (+) + (+) -> (-)
		and .LC2, %rax # teraz 10000000 lub 00000000
		and %rax, %r9 # 1 jesli bedzie trzeba dodac 1 do wyniku
		shr $7, %rax # teraz 1 lub 0
		mul .LC5 # teraz 01111111 lub 00000000

		# teraz %r9 wygląda tak: 01111111, 11111111 lub 00000000 (tzn kazdy z wektorow),
		# przy czym 11111111 jesli obie ujemne i wyszlo ponizej -128, albo wyszlo akurat -1
		or %rax, %rcx # jesli bylo przepelnienie to dodaje
		# teraz tylko trzeba dodac 1 jesli bylo ponizej ujemnego i gotowe
		shr $7, %r9

		# nie chcemy starych śmieci w %rcx, więc:
		
		and .LC7, %rcx
		add %r9, %rcx

		# nie dziala dla dodawania dwoch dodatnich, kiedy wyszlo ujemne, bo chcemy wtedy wyczyscic 1 bit
		# or .LC8, %r10
		sub %r10, %rcx

		# add */



		# "Zero Fellings" Zoe Clark