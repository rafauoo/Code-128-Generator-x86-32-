;=====================================================================
; ARKO - projekt x86-32
;
; author:      Rafał Budnik
; date:        2022.06.01
; description: x86 (32-bit) - function that copies 1st line to line_number-th line
;              char* extend_line(char* pImg, int line_number)
;				returns pImg (data bitmap) with copied line
;-------------------------------------------------------------------------------

section	.text
global  extend_line

extend_line:
	push ebp
	mov	ebp, esp
    mov ecx, [ebp+8] ; pImg writer
    mov edx, [ebp+12] ; line number
    mov eax, 2304
    mul edx
    add ecx, eax
    xor edx, edx
    mov eax, [ebp+8] ; pImg reader
    .write_line_loop:
        push dx
        mov dh, [eax]
        mov [ecx], dh
        pop dx
        inc ecx
        inc eax
        inc dx
        cmp dx, 2304
        jne .write_line_loop
	.quit:
		mov eax, [ebp+8]
		pop	ebp
		ret

