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
        .globl  clz
        .type   clz, @function

/*
 * W moim rozwiązaniu używam następującej techniki: wykonuję przejścia i w każdym z nich sprawdzam, czy kolejne (w rozumieniu od początku lub od ostatniego sprawdzonego zera) k miejsc jest zerami (gdzie k to 32, 16, ..., 2, 1) i na końcu jeszcze sprawdzam czy cała liczba jest zerem. Przy każdym przejściu jeśli te wszystkie miejsca sprawdzane były zerami to dodaję k do wyniku.
 */

clz:
    movq $32, %rax
	movq %rdi, %rdx
	shrq $32, %rdx /* sprawdzam czy lewe 32 bity są zerami, więc shiftuję tak, by tylko one były i przyrównuję do 0*/
	negq %rdx /* CF = 1 jeśli było coś innego niż zera */
	sbb %rdx, %rdx /*0 jeśli były same 0, wpp -1*/
	inc %rdx /* 1 jesli byly same 0, wpp 0*/
	mulq %rdx /*32 lub 0 <- wynik*/
	movq $32, %rcx /* jesli jest sens przesuwam rdi o 32 bity, żeby sprawdzać tylko te niewiadomo-czy-zerowe and-ując z liczbami 32-bitowymi*/
	subq %rax, %rcx /* 32 jesli byly nie-zera*/
	shr %cl, %rdi /* jesli pierwsze 32 bity nie byly zerami to shift*/
	movq %rax, %r8 /* zapisuję na później wartość rax, czyli czy są 32 zera czy nie na początku*/
	movq $0, %rcx /* ustawiam rcx na 0 (potem potrzebne)*/
	movq $4294901760, %rdx /*ustawiam rdx na FFFF0000, czyli sprawdzam "pierwsze" 16 cyfr, czy są zerami*/
	andq %rdi, %rdx /*>0 jak tam nie bylo zer */
	negq %rdx /*CF = 1 jesli było coś nie-zerowego*/
	sbbq %rdx, %rdx
	inc %rdx
	leaq (%rcx , %rdx, 8), %rcx /*dodaję 16 * rdx, czyli 16 lub 0, zależnie czy były same zera, czy nie*/
	leaq (%rcx, %rdx, 8), %rcx
	movq $4278190080, %rdx /*ustawiam rdx na FF000000 (sprawdzam "pierwsze" 8)*/
	shrq %cl, %rdx /*shiftuję rdx o cl, czyli ile do tej pory było (od 16 licząc), żeby sprawdzić "nowe" miejsca*/
	andq %rdi, %rdx /* >0 jak tam nie bylo zer*/
	negq %rdx /*CF = 1 jesli nie-zerowe*/
	sbbq %rdx, %rdx
	incq %rdx /*1 jesli same zera, wpp 0*/
	leaq (%rcx, %rdx, 8), %rcx /*dodaję 8 jeśli same zera*/
	movq $4026531840, %rdx /*podobnie do poprzednich, sprawdzam 4 "kolejne"*/
	shrq %cl, %rdx
	andq %rdi, %rdx /*>0 jak tam nie bylo zer */
	negq %rdx /*CF = 1 jesli dodatnie*/
	sbbq %rdx, %rdx
	incq %rdx
	leaq (%rcx, %rdx, 4), %rcx /*jeśli były same zera to +4 do wyniku*/
	movq $3221225472, %rdx /*2 kolejne*/
	shrq %cl, %rdx
	andq %rdi, %rdx /*>0 jak tam nie bylo zer */
	negq %rdx /*CF = 1 jesli dodatnie*/
	sbbq %rdx, %rdx
	incq %rdx
	leaq (%rcx, %rdx, 2), %rcx /*jesli same zera to +2*/
	movq $2147483648, %rdx/*1 kolejne*/
	shrq %cl, %rdx
	andq %rdi, %rdx /*>0 jak tam nie bylo zer */
	negq %rdx /*CF = 1 jesli dodatnie*/
	sbbq %rdx, %rdx
	leaq 1(%rcx, %rdx), %rcx /*jesli były same 0 to dodaję (1 + 0) = 1, wpp (1 + -1) = 0*/
	negq %rdi /* jesli 0 to CF=0, jak nie to 1 (sprawdzam czy całość jest zerem, bo tylko wtedy może być suma 64)*/
	sbbq $0, %r8 /*dla 0 jest 0, jak nie -1*/
	leaq 1(%r8, %rcx), %rax /* dodaje jeden jesli CF=0 */
	ret

        .size   clz, .-clz
