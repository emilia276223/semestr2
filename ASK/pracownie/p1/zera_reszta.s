	;w rdi jest x

	;tu musze jeszcze zpopowac jesli czegos uzywam a nie powinnam
	
	;xor %r10, %r10 ;tu bedzie wynik
	;wyzej wyczyszczenie potrzebnych

;	mov %rdi, %r9
;	and 0xFFFFFFFF00000000, %r9 ;>0 jak tam nie bylo zer
;	neg %r9 ;CF = 1 jesli dodatnie
;	sbb %r9, %r9 ;0 lub -1
;	inc %r9 ; 0 jesli nie dodajemy, 1 jesli tak
;	mul 0x20, %r9
;	add %r9, %rax
;
;	mov %rdi, %r9
;
;	and 0xFFFF0000, %r9 ;>0 jak tam nie bylo zer
;	neg %r9 ;CF = 1 jesli dodatnie
;	sbb %r9, %r9 ;0 lub -1
;	inc %r9 ; 0 jesli nie dodajemy, 1 jesli tak
;	mul 0x20, %r9
;	add %r9, %rax




;	ret



;II wersja (z jumpem)
;poczatek taki sam