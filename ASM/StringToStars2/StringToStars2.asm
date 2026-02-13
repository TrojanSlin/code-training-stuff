global  _start

section .text
; -------- read_sym(param1) ---------
; read single letter to addres
; param1 - where to write text
read_sym:
	push	ebp		; prologue
	mov	ebp, esp

	mov	eax, 3		; read interrupt code
	mov	ebx, 0		; read from standart input
	mov	ecx, [ebp+8]	; get addres for reading
	mov	edx, 1		; read single
	int	80h		; call interupt

	pop	ebp		; exiting
	ret

; macros for read_sym
%macro	READ_SYM 1 ; 
	push	%1		; load param1
	call	read_sym	; call function
	pop	%1		; unload param1
%endmacro


; -------- write_sym(param1) ---------
; write single letter from stack
; param1 - what symbol to write text
write_sym:
	push	ebp		; prologue
	mov	ebp, esp
	pusha

	mov	eax, 4		; write interrupt code
	mov	ebx, 1		; write into standart output
	mov	ecx, ebp	; get addres of symbol to write
	add	ecx, 8
	mov	edx, 1		; write single character
	int	80h		; call interupt

	popa			; exiting
	pop	ebp
	ret

; macros for write_sym
%macro	WRITE_SYM 1 ; 
	push	%1		; load param1
	call	write_sym	; call function
	add	esp, 4		; remove param1
%endmacro


; ----- convert_string(param1) -------
; read string from standart input and
; write it as a stars symbols
; param1 - memory to operate, 1 byte needed
convert_string:
	push	ebp		; prologue
	mov	ebp, esp

	mov	ebx, [ebp+8]	; save param1 addres in EBX
.loop_start:
	READ_SYM ebx		; read symbol and write it to param1
	cmp	eax, 1		; if result is EOF or error then exit
	jl	.loop_exit
	mov	al, [ebx]	; write symbol to EAX

	cmp	al, " "		; if symbol is space then write it
	je	.write
	cmp	al, 10		; if symbol is line break then write it
	je	.write
	cmp	al, 9		; if symbol is tab then write it
	je	.write
	mov	eax, "*"	; else save * to eax

.write:	WRITE_SYM eax		; write symbol
	jmp	.loop_start	; repeat cycle
.loop_exit:
	pop	ebp		; exit
	ret

; macros for convert_string
%macro	CONVERT_STRING 1 ;
	push	%1		; load param1
	call	convert_string	; call function
	add	esp, 4		; remove param1
%endmacro

_start:	CONVERT_STRING txt

_exit:	mov	eax, 1		; exit
	mov	ebx, 0
	int	80h

section .bss
txt	resb	1
