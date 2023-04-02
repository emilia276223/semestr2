
//zadanie 5 wersja dluga
movq    %rdi, %r8 
movq    %rdi, %r9
andq    $0xFF00FF00, %r8
andq    $0x00FF00FF, %r9
rol     %r8d, 8
ror     %r9d, 8
orq     %r9, %r8
movq    %r8, %rax

//zadanie 5 wersja krotka
movl    %edi, %eax // 1234
rol     $8, %ax    // 1243
rol     $16, %eax  // 4312
rol     $8, %ax    // 4321

//zadanie 6

addq %rsi, %rcx
adc  %rdi, %rdx
movq %rcx, %rax

//zadanie 7
mov %rdx, %rax
mul %rsi         // x0 * y1
mov %rax, %r8
mov %rdi, %rax
mul %rcx         // x1 * y0
add %rax, %r8
mov %rsi, %rax
mul %rcx         // x0 * y0
add %r8, %rdx


