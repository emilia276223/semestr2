	.globl	zera
	.text
zera:
	movq $32, %rax
	movq %rdi, %rdx
	shrq $32, %rdx
	negq %rdx /* CF = 1 jesli dodatnie */
	sbb %rdx, %rdx /*-1 jesli nie 0 */
	inc %rdx /* 1 jesli byly same 0, wpp 0*/
	mulq %rdx /*32 lub 0 <- wynik*/
	movq $32, %rcx
	subq %rax, %rcx /* 32 jesli byly nie-zera*/
	shr %cl, %rdi
	movq %rax, %r8
	movq $0, %rcx
	movq $4294901760, %rdx
	andq %rdi, %rdx /*>0 jak tam nie bylo zer */
	negq %rdx /*CF = 1 jesli dodatnie*/
	sbbq %rdx, %rdx
	inc %rdx
	leaq (%rcx , %rdx, 8), %rcx
	leaq (%rcx, %rdx, 8), %rcx
	movq $4278190080, %rdx
	shrq %cl, %rdx
	andq %rdi, %rdx /* >0 jak tam nie bylo zer*/
	negq %rdx /*CF = 1 jesli dodatnie*/
	sbbq %rdx, %rdx
	incq %rdx
	leaq (%rcx, %rdx, 8), %rcx
	movq $4026531840, %rdx
	shrq %cl, %rdx
	andq %rdi, %rdx /*>0 jak tam nie bylo zer */
	negq %rdx /*CF = 1 jesli dodatnie*/
	sbbq %rdx, %rdx
	incq %rdx
	leaq (%rcx, %rdx, 4), %rcx
	movq $3221225472, %rdx
	shrq %cl, %rdx
	andq %rdi, %rdx /*>0 jak tam nie bylo zer */
	negq %rdx /*CF = 1 jesli dodatnie*/
	sbbq %rdx, %rdx
	incq %rdx
	leaq (%rcx, %rdx, 2), %rcx
	movq $2147483648, %rdx
	shrq %cl, %rdx
	andq %rdi, %rdx /*>0 jak tam nie bylo zer */
	negq %rdx /*CF = 1 jesli dodatnie*/
	sbbq %rdx, %rdx
	leaq 1(%rcx, %rdx), %rcx
	negq %rdi /* jesli 0 to CF=0, jak nie to 1 */
	sbbq $0, %r8 /*dla 0 jest 0, jak nie -1*/
	leaq 1(%r8, %rcx), %rax /* dodaje jeden jesli CF=0 */
	ret

	/*stara wersja*/
/*	xor %rax, %rax # wyczyszczenie rax-a
	movq %rdi, %r9
	andq 0xFFFFFFFF, %r9 #>0 jak tam nie bylo zer
	neg %r9 # CF = 1 jesli dodatnie
	jb .L1 # jesli nie 0 to jump
	addq $32, %rax
.L1: movq 0xFFFF0000, %r9
	shl %rax, %r9
	andq %rdi, %r9 #>0 jak tam nie bylo zer
	neg %r9 # CF = 1 jesli dodatnie
	jb .L2 # jesli nie 0 to jump
	addq $16, %rax
.L2:movq 0xFF00, %r9
	shl %rax, %r9
	and %rdi, %r9 #>0 jak tam nie bylo zer
	neg %r9 # CF = 1 jesli dodatnie
#	jb .L3 # jesli nie 0 to jump
#	add $8, %rax
	sbb %r9, %r9
	inc %r9
	lea (%rax, %r9, 8), %rax
.L3: movq 0xF0, %r9
	shl %rax, %r9
	and %rdi, %r9 #>0 jak tam nie bylo zer
	neg %r9 # CF = 1 jesli dodatnie
#	jb .L4 # jesli nie 0 to jump
#	add $4, %rax
	sbb %r9, %r9
	inc %r9
	lea (%rax, %r9, 4), %rax
.L4: movq 0xC, %r9
	shl %rax, %r9
	and %rdi, %r9 #>0 jak tam nie bylo zer
	neg %r9 # CF = 1 jesli dodatnie
#	jb .L5 # jesli nie 0 to jump
#	add $2, %rax
	sbb %r9, %r9
	inc %r9
	lea (%rax, %r9, 2), %rax
.L5: movq 0x2, %r9
	shl %rax, %r9
	and %rdi, %r9 #>0 jak tam nie bylo zer
	neg %r9 # CF = 1 jesli dodatnie
#	jb .L6 # jesli nie 0 to jump
#	add $1, %rax
	sbb %r9, %r9
	inc %r9
	lea (%rax, %r9), %rax
.L6: 
	# to się działo tylko dla rdi == 0 wiec mozna ten przypadek osobno
#	movq 0x1, %r9 
#	shl %rax, %r9
#	and %rdi, %r9 #>0 jak tam nie bylo zer
#	neg %r9 #CF = 1 jesli dodatnie
#	jb .L7 #jesli nie 0 to jump
#	add $1, %rax
	neg %rdi # jesli 0 to CF=0, jak nie to 1
	sbb %r9, %r9 # dla 0 jest 0, jak nie -1
	lea 1(%r9, %rax), %rax # dodaje jeden jesli bylo 1 

.L7: ret */