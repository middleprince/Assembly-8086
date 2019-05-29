; 实验 13-2-function 功能模块
;run the program and whem it run every step display a message in sceen .

assume cs:code

code segment
	start:mov ax,cs
	mov ds,ax
	mov si,offset be

	mov ax,0
	mov es,ax
	mov di,0200h

	cld 
	mov cx,offset showend-offset be
	rep movsb

	
	mov word ptr es:[4],0200h				;write the int 7ch position into vector table
	mov word ptr es:[4].2,0000h
	
		pushf
		pop ax
		or ax,100000000b
		push ax
		popf

			mov di,160*2

		mov ax,2
		inc ax
		inc ax
		inc ax

	mov ax,4c00h
	int 21h 

	be: push ax
		push es
		mov ax,0b800h
		mov es,ax
		mov al,4
cicle:	mov ah,'!'
		mov es:[di],ax
		inc di 
		inc di
		pop es
		pop ax
outside:	iret
	showend:nop



code ends
end start