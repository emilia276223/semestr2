/*
 * UWAGA! W poniższym kodzie należy zawrzeć krótki opis metody rozwiązania
 *        zadania. Będzie on czytany przez sprawdzającego. Przed przystąpieniem
 *        do rozwiązywania zapoznaj się dokładnie z jego treścią. Poniżej należy
 *        wypełnić oświadczenie o samodzielnym wykonaniu zadania.
 *
 * Oświadczam, że zapoznałem(-am) się z regulaminem prowadzenia zajęć
 * i jestem świadomy(-a) konsekwencji niestosowania się do podanych tam zasad.
 *
 * Imię i nazwisko, numer indeksu: Emilia Wiśniewska, 338778 
 */

        .text
        .globl  addsb
        .type   addsb, @function

/*
 * W moim rozwiązaniu używam następującej techniki: ____ ____ ____ ____
 */


addsb:
/*
	$0x7F7F7F7F7F7F -> wszystkie bity poza 1
	$0x808080808080 -> pierwsze bity

	stare:  nowe:
	różne         -> dobrze
	a		b 	  -> źle (0111111)  lub +1
	1	1	  -> dobrze
	0	0	  -> dobrze
	a1 - pierwsze bity pierwszej
	xor a1, a2
	xor a1, w
	or a1, w <- mam 1 jesli nie mam zmieniac liczby, wpp 0
	# zamiana 0 <-> 1
	mul 0x01111111 - w tych miejscach gdzie nadpisac
	and wn, ws

	1001010101 & 011111111 -> ff
	7f
	# jesli w jest 1(w) oraz a1 i a2 = 0 to (xor w, 1)
	jesli or(a1, a2) = 0 to xor z w
	or
	# zamiana 1 <-> 0 a
	and a1, w
	xor w, wynik


 */
	# wzięcie pierwszych bitów pierwszej, drugiej i wyniku
	# A
	mov $0x7F7F7F7F7F7F7F7F, %r10
	mov %rdi, %r8 # pierwsza
	mov %rsi, %r9 # druga
 	and %r10, %rsi
	and %r10, %rdi
	add %rsi, %rdi # suma (bez pierwszych bitów)


	# mov %rdi, %rsi
	# and .LC2, %rsi # pierwsze bity wyniku

	# chcę zmienić jeśli pierwsze bity liczb takie same i inne od wynikowego
	# B
	xor %r8, %r9 
	mov $0x8080808080808080, %r10
	and %r10, %r9 # 1 jesli różne pierwsze bity, wpp 0
	
	# zobaczmy czy teraz bedzie dzialac
	shr $7, %r9

	xor %rdi, %r8
	and %r10, %r8 # 1 jesli rozne pierwsze bity pierwszej liczby i wyniku, wpp 0 

	# chce napisać tylko gdy %r9 = 0 oraz %r8 = 1
	# C
	xor %r10, %r10
	sub %r9, %r10
	mov $0x0101010101010101, %r9
	add %r10, %r9 # 1 jesli bylo 0, 0 wpp
	mov $0x0101010101010101, %r10
	and %r10, %r9 # takie same pierwsze bity

	shr $7, %r8
	and %r8, %r9 # 1 jesli chce napisac, 0 wpp
	mov %r9, %rax


	movq $0x7F, %r10 
	mul %r10 # odpowiednio 0111111 jesli chce napisac, wpp 00000000
	# nadpisanie:
	or %rax, %rdi

	# juz prawie dziala, trzeba jeszcze wyzerowac pierwszy bit jesli 
	# bylo nadpisywane (r8 = 0) a wynik byl ujemny (czyli na poczatku obie dodatnie), czyli 

	

	
	mov	%rdi, %rax
    ret

    .size   addsb, .-addsb 
