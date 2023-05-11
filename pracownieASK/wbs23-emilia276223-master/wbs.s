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
        .globl  wbs
        .type wbs, @function

/*
 * W moim rozwiązaniu używam następującej techniki: ____ ____ ____ ____
 */

.LC1: .quad 0xAAAAAAAAAAAAAAAA
.LC2: .quad 0xCCCCCCCCCCCCCCCC
.LC3: .quad 0xF0F0F0F0F0F0F0F0
.LC4: .quad 0xFF00FF00FF00FF00
.LC5: .quad 0xFFFF0000FFFF0000
.LC6: .quad 0xFFFFFFFF00000000

wbs:
	mov %rdi, %rcx
	and .LC1, %rcx
	popcnt %rcx, %rax

	mov %rdi, %rcx
	and .LC2, %rcx
	popcnt %rcx, %rcx
	shl $1, %rcx
	add %rcx, %rax

	mov %rdi, %rcx
	and .LC3, %rcx
	popcnt %rcx, %rcx
	shl $2, %rcx
	add %rcx, %rax

	mov %rdi, %rcx
	and .LC4, %rcx
	popcnt %rcx, %rcx
	shl $3, %rcx
	add %rcx, %rax
	
	mov %rdi, %rcx
	and .LC5, %rcx
	popcnt %rcx, %rcx
	shl $4, %rcx
	add %rcx, %rax

	mov %rdi, %rcx
	and .LC6, %rcx
	popcnt %rcx, %rcx
	shl $5, %rcx
	add %rcx, %rax
	ret

	ret

	.size wbs, .-wbs
