global  _start

section .data
txt	db	"le suson", 10		; text to convert into stars
txt_len equ      $-txt			; length of text
star	db	"*"


section .text
; 1 - param - a symbol to write
write_save:
	push	ebp			; prologue
	mov	ebp, esp
	pusha

	mov	eax, 4			; write interrupt code
	mov	ebx, 1			; write into standart output
	mov	ecx, ebp		; get addres of symbol to write
	add	ecx, 8
	mov	edx, 1			; write single character
	int	80h			; call interupt

	popa				; exiting
	pop	ebp
	ret

write_sim_star:
	xor	ecx, ecx		; clear ecx
	mov	ebx, txt_len		; write length of string
.loop_start:
	cmp	ecx, ebx		; if ecx more then string length exit
	jge	.loop_exit

	mov	al, [txt+ecx]		; write ecx-th symbol to eax
	cmp	al, " "			; if its " " write it
	je	.write
	cmp	al, 10			; if its lite break write it
	je	.write
	mov	eax, [star]		; else write "*" to eax

.write:	push	eax			; load param of write_save
	call	write_save
	add	esp, 4			; unload it
	inc	ecx			; go to next symbol
	jmp	.loop_start		; repeat cycle
.loop_exit:
	ret


_start: call	write_sim_star	

	mov	eax, 1		; exit
	mov	ebx, 0
	int	80h
