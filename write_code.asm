;=====================================================================
; ARKO - projekt x86-32
;
; author:      Rafał Budnik
; date:        2022.06.01
; description: x86 (32-bit) - function that writes one letter(sign) in code128
;              char* write_code(const char* code, int length, int start_pixel, char* pImg)
;				returns pImg with that sign
;-------------------------------------------------------------------------------

section	.text
global  write_code

write_code:
	push ebp
	mov	ebp, esp
	mov eax, [ebp+8] ; string
	mov ecx, [ebp+20]
	mov edx, [ebp+16] ; pixel pos
	add ecx, edx
	.loop:
		mov dl, [eax]
		cmp dl, 0	; if end of string -> quit
		je .quit
		cmp dl, '1'	; if char is "[" -> found_open
		je .write_black

	.write_white:
		mov dh, 255
		mov [ecx], dh
		mov [ecx+1], dh
		mov [ecx+2], dh
		add ecx, 3
		inc eax
		cmp eax, eax
		je .loop

	.write_black:
		mov dh, 0
		mov [ecx], dh
		mov [ecx+1], dh
		mov [ecx+2], dh
		add ecx, 3
		inc eax
		cmp eax, eax
		je .loop

	.quit:
		mov eax, [ebp+20]
		pop	ebp
		ret

