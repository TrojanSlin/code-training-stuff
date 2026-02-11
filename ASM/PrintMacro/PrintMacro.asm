global  _start

%macro  PRINT_SEC 1
section .data
%%txt   db      %1
%%txt_len equ    $-%%txt

section .text
        mov     eax, 4
        mov     ebx, 1
        mov     ecx, %%txt
        mov     edx, %%txt_len
        int     80h
%endmacro

%macro  PRINTF   1-*
        pusha
%rep %0
        PRINT_SEC %1
%rotate -1
%endrep
        popa
%endmacro

section .text
_start:	PRINTF   "Le text", 10, "smth else", 10

_exit:  mov     eax, 1
        mov     ebx, 0
        int     80h
