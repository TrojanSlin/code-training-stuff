%include "stud_io.inc"
global  _start

section .text

; convert number to string and print it
; param 1 - number to print
write_func:
        ; PROLOGUE              ; creating frame
        push    ebp             ; it needs 1 variable for letter
        mov     ebp, esp

        ; MAIN PART
        mov     eax, [ebp+8]     ; get whats left from number
        test    eax, eax         ; if 0 exit
        jz      .exit
        mov     ebx, 10          ; write 10 to divide number by it
        xor     edx, edx         ; clear EDX for to write result of division
        div     ebx              ; get single digit from it by dividing
        add     dl, 48           ; add '0' ascii code to number
        push    edx              ; save
        push    eax
        call    write_func

        ; WRITING LETTER
        pop     ebx
        PUTCHAR bl
        ; EXIT
.exit:  mov     esp, ebp
        pop     ebp
        ret     4


_start:	mov     eax, 100
        push    eax
        call    write_func
        PUTCHAR 10
	FINISH
