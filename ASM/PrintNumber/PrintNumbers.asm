%include "stud_io.inc"
global  _start

section .text

; convert number to string and print it
; EAX - number to print
write_func:
        xor     edx, edx        ; prep edx for getting remainder
        mov     ecx, 10         ; div by 10 to get last number
        div     ecx
        test    eax, eax        ; check if nothing left in EAX
        jz      .exit           ; if so print number and exit
        push    edx             ; if not remember number
        call    write_func      ; call itslef to get nex number
        pop     edx             ; when recursion closes get number back
.exit:  add     edx, 48         ; add 0 ascii code
        PUTCHAR dl              ; print number
        ret


_start:	mov     eax, 00
        call    write_func
        PUTCHAR 10

        mov     eax, 100
        call    write_func
        PUTCHAR 10

        mov     eax, 1001
        call    write_func
        PUTCHAR 10

        mov     eax, 6543
        call    write_func
        PUTCHAR 10
	FINISH
