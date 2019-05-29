; 实验 13-1
; 实现 int 7ch 中断，显示以0结束的字符串，并且将中断安装在0：200处。
;the 7ch function
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

	mov al,1
	mov bl,4
	mul bl
	mov bx,ax
	
	mov word ptr es:[bx],0200h				;write the int 7ch position into vector table
	mov word ptr es:[bx].2,0000h

	mov ax,4c00h
	int 21h

	be: 
		mov ax,0b800h
		mov es,ax 
		mov di,0000h
		
		mov al,160
		mul dh				;row
		add di,ax

		mov al,2			;column
		sub dl,1
		mul dl
		add di,ax

		mov ah,cl

cicle:	mov al,[si]
		cmp al,0
		je outside
		mov es:[di],ax
		inc di
		inc di
		inc si
		jmp short cicle

outside:	iret
	showend:nop



code ends
end start