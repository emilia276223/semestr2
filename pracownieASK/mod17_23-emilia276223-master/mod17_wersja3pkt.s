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
		
	mov %rdi, %rax
	mov %rdi, %rsi
	and .LC1, %rdi /*te co mam dodac */
	and .LC2, %rax /*te co mam odjac */
	# nie bawie sie z pierwszym bitem bo to jest int a nie uint

	# teraz z druga czescia
	# policzenie, ile mam odjac = zsumowanie 
	mov %rdi, %r9
	shr $32, %r9
	add %r9, %rdi /*w pierwszych 32 bitach mam liczby ktore sa do zsumowania */
	/*tutaj jeszcze dziala */
	mov %rdi, %r9
	shr $16, %r9
	add %r9, %rdi /*w pierwszych 16 bitach mam 4 liczby ktore sa do zsumowania */
	/*liczy dobrze */
	mov %rdi, %r9
	shr $8, %r9
	lea (%r9, %rdi), %rcx/*w pierwszych 8 bitach mam 2 liczby ktore sa do zsumowania*/
	/*tutaj dziala */

	shr $4, %rax
	# policzenie, ile mam odjac = zsumowanie 
	mov %rax, %r9
	shr $32, %r9
	add %r9, %rax /*w pierwszych 32 bitach mam liczby ktore sa do zsumowania */
	/*tutaj jeszcze dziala */
	mov %rax, %r9
	shr $16, %r9
	add %r9, %rax /*w pierwszych 16 bitach mam 4 liczby ktore sa do zsumowania */
	/*liczy dobrze */
	mov %rax, %r9
	shr $8, %r9 
	add %r9, %rax /*w pierwszych 8 bitach mam 2 liczby ktore sa do zsumowania, sumuje */
	/*tutaj dziala */
	# and $0xFFF, %rax /*czyszcze stare bity*/


	# teraz mamy juz zsumowane liczby z tych bitow do dodania i do odjecia
	and $0xFF, %rax
	and $0xFF, %rcx
	sub %rax, %rcx
	# do tego miejsca 25 instrukcji (mam jezcze 10)

	# sbb %rdx, %rdx /* zapisujemy na pozniej czy wyszlo ujemne */

	# do tego miejsca wynik jest poprawny, ale jeszcze nie jest to reszta (wynik miedzy 120 (78) a -120 (-78))

	# mov %rcx, %rax
	# sar $4, %rax
	
	# sub %rax, %rcx
	# dodatkowo odejmuje 1 jesli byly ujemne / dodaje 1
	# sub %rdx, %rcx
.L1:	sub $17, %rcx
	cmp $0, %rcx
	jge .L1
.L2:	add $17, %rcx
	cmp $0, %rcx
	jl .L2



	mov %rcx, %rax
	ret

    .size   mod17, .-mod17

	# 18:00
