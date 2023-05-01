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
        .globl  bitrev
        .type bitrev, @function

/*
 * W moim rozwiązaniu używam następującej techniki: "dziel i zwyciężaj":
 Zamieniam kolejnością najpierw 32-bitowe elementy, potem 16, 8, 4, 2 i 1 bitowe. Dzięki temu w sumie
 każdy element przechodzi na symetryczne miejsce, a operacje zamiany wszystkich (2^k) - bitowych elementów (dla danego k)
 mogę wykonać w czasie stałym, ponieważ robię to jednocześnie
 */
.LC1: .quad 0xFFFF0000FFFF
.LC2: .quad 0xFF00FF00FF00FF
.LC3: .quad 0xF0F0F0F0F0F0F0F
.LC4: .quad 0x3333333333333333
.LC5: .quad 0x5555555555555555

bitrev:
	# zamiana 32-itowych czesci (ror tu dziala idealnie, bo zamienia mi prawe 32 bity miejscami z lewymi)
	ror $32, %rdi
	# zamiana 16-bitowych czesci
	mov %rdi, %r9 # ABCD
	and .LC1, %rdi # 0B0D
	xor %rdi, %r9 # A0C0 
	shr $16, %r9 # A0C
	shl $16, %rdi # B0D0
	leaq (%r9, %rdi), %rdi # BADC
	# zamiana 8-bitowych czesci
	mov %rdi, %r9 # 
	and .LC2, %rdi # 
	xor %rdi, %r9 # 
	shr $8, %r9 # 
	shl $8, %rdi # 
	leaq (%r9, %rdi), %rdi
	# zamiana 4-bitowych czesci
	movq %rdi, %r9
	andq .LC3, %rdi
	xor %rdi, %r9 # 
	shr $4, %r9 # 
	shl $4, %rdi # 
	leaq (%r9, %rdi), %rdi
	# zamiana 2-bitowych czesci
	mov %rdi, %r9 # 
	and .LC4, %rdi # 
	xor %rdi, %r9 #
	shr $2, %r9 # 
	leaq (%r9, %rdi, 4), %rdi
	# zamiana 1-bitowych
	movq .LC5, %r8
	and %rdi, %r8
	xor %r8, %rdi #
	shr $1, %rdi #
	leaq (%rdi,%r8, 2), %rax
	ret

		.size bitrev, .-bitrev

