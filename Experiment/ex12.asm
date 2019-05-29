; 实验 12
; 实现 0 号中断，在除法溢出时在屏幕中显示字符 “divide error”
assume cs:code

code segment

start:	mov ax,cs
		mov ds,ax
		mov si,offset d0

		mov ax,0h
		mov es,ax
		mov di,200h
		
		mov cx,offset d0end-offset d0
		cld
		rep movsb

		mov ax,0000h
		mov es,ax 
		mov word ptr es:[0].2,0000h
		mov word ptr es:[0],0200h

		mov ax,1000
		mov bl,1
		div bl
		
		mov ax,4c00h
		int 21h



	d0:	jmp short d0start
		db "divide errro"

d0start:mov ax,cs
		mov ds,ax
		mov si,202h
		mov ax,0b800h
		mov es,ax
		mov di,12*120+32*2

		mov cx,12
	s:	mov al,[si]
		mov ah,4

		mov	es:[di],ax 
		inc si
		inc di
		inc di
		loop s

		mov ax,4c00h
		int 21h
d0end: 	nop

code ends
end start
