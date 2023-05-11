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
        .globl  mod17
        .type   mod17, @function

/*
 * W moim rozwiązaniu używam następującej techniki: ____ ____ ____ ____
 */

.LC1: .quad  0xF0F0F0F0F0F0F0F
.LC2: .quad 0xF0F0F0F0F0F0F0F0

mod17:
	mov %rdi, %rcx
	and .LC1, %rdi /*te co mam dodac */
	and .LC2, %rcx /*te co mam odjac */
	# nie bawie sie z pierwszym bitem bo to jest int a nie uint

	# teraz z druga czescia
	# policzenie, ile mam odjac = zsumowanie 
	mov %rdi, %r9
	shr $32, %r9
	add %r9, %rdi /*w pierwszych 32 bitach mam liczby ktore sa do zsumowania */

	mov %rdi, %r9
	shr $16, %r9
	add %r9, %rdi /*w pierwszych 16 bitach mam 4 liczby ktore sa do zsumowania */

	mov %rdi, %r9
	shr $8, %r9
	lea (%r9, %rdi), %rax/*w pierwszych 8 bitach mam 2 liczby ktore sa do zsumowania*/


	shr $4, %rcx
	# policzenie, ile mam odjac = zsumowanie 
	mov %rcx, %r9
	shr $32, %r9
	add %r9, %rcx /*w pierwszych 32 bitach mam liczby ktore sa do zsumowania */

	mov %rcx, %r9
	shr $16, %r9
	add %r9, %rcx /*w pierwszych 16 bitach mam 4 liczby ktore sa do zsumowania */

	mov %rcx, %r9
	shr $8, %r9 
	add %r9, %rcx /*w pierwszych 8 bitach mam 2 liczby ktore sa do zsumowania, sumuje */

	# teraz mamy juz zsumowane liczby z tych bitow do dodania i do odjecia
	and $0xFF, %rcx
	and $0xFF, %rax
	sub %rcx, %rax
	# do tego miejsca 25 instrukcji (mam jezcze 10)

	mov %rax, %rcx
	and $0x800, %rcx
	shr $11, %rcx
	mov %rax, %rdi
	and $0xF0, %rdi
	shr $4, %rdi
	and $0xF, %rax
	sub %rdi, %rax
	sub %rcx, %rax
	mov %rax, %r10
	and $0x100, %r10
	shr $8, %r10


	lea (%r10, %r10, 8), %rcx
	lea (%rcx, %r10, 8), %rcx
	add %rcx, %rax

	ret
    .size   mod17, .-mod17

